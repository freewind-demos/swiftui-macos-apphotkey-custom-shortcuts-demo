import AppKit
import Foundation

/// 最近一次触发记录。
struct TriggeredHotkeyEvent: Identifiable {
  /// 唯一 id。
  let id = UUID()
  /// 触发动作。
  let action: DemoShortcutAction
  /// 触发时的热键文案。
  let hotkeyName: String
  /// 触发来源。
  let source: String
  /// 触发时间。
  let happenedAt: Date
}

/// 根状态。
@MainActor
final class HotkeyDemoStore: ObservableObject {
  /// 当前绑定表。
  @Published var bindings: DemoHotkeyBindings
  /// 最新提示。
  @Published var latestMessage: String
  /// 最近日志。
  @Published var eventLog: [TriggeredHotkeyEvent]
  /// 是否正在录制。
  @Published var isRecording: Bool

  /// 默认初始化。
  init(bindings: DemoHotkeyBindings = .default) {
    // 收下初始绑定。
    self.bindings = bindings
    // 初始提示。
    latestMessage = "按左侧任一快捷键，右侧会显示你刚才激活了什么动作。"
    // 初始日志为空。
    eventLog = []
    // 初始不在录制态。
    isRecording = false
  }

  /// 改某个动作的快捷键。
  func updateHotkey(_ hotkey: AppHotkey, for action: DemoShortcutAction) {
    // 原地改绑定。
    bindings.set(hotkey, for: action)
    // 立即给出反馈。
    latestMessage = "已把 \(action.title) 绑定成 \(hotkey.displayName)。"
  }

  /// 切录制态。
  func setRecording(_ value: Bool) {
    // 只维护布尔值。
    isRecording = value
  }

  /// 清空日志。
  func clearLog() {
    // 清空数组。
    eventLog = []
    // 同步改提示。
    latestMessage = "日志已清空。"
  }

  /// 恢复默认绑定。
  func resetToDefaults() {
    // 用默认值整表覆盖。
    bindings = .default
    // 同步提示。
    latestMessage = "已恢复默认快捷键。"
  }

  /// 处理真实按键。
  func handleKeyDown(_ event: NSEvent) -> Bool {
    // 录制期间不消费。
    if isRecording {
      return false
    }
    // 逐个动作比对。
    for action in DemoShortcutAction.allCases {
      // 拿到动作热键。
      let hotkey = bindings.hotkey(for: action)
      // 命中就触发。
      if hotkey.matches(event) {
        trigger(action, source: "Keyboard")
        return true
      }
    }
    // 未命中就放行。
    return false
  }

  /// 手动触发某个动作。
  func trigger(_ action: DemoShortcutAction, source: String) {
    // 读当前热键文案。
    let hotkeyName = bindings.hotkey(for: action).displayName
    // 写最新提示。
    latestMessage = "刚才激活了 \(action.title)。"
    // 头插一条日志。
    eventLog.insert(
      .init(
        action: action,
        hotkeyName: hotkeyName,
        source: source,
        happenedAt: Date()
      ),
      at: 0
    )
    // 日志最多保留 20 条。
    eventLog = Array(eventLog.prefix(20))
  }

  /// 重复绑定提示。
  var duplicateWarnings: [String] {
    // 把热键文案聚合到动作列表。
    let grouped = Dictionary(
      grouping: DemoShortcutAction.allCases,
      by: { bindings.hotkey(for: $0).displayName }
    )
    // 只保留重复项。
    return grouped
      .filter { $0.value.count > 1 }
      .sorted { $0.key < $1.key }
      .map { hotkeyName, actions in
        let titles = actions.map(\.title).joined(separator: ", ")
        return "\(hotkeyName): \(titles)"
      }
  }

  /// 当前绑定的 JSON 预览。
  var bindingsJSON: String {
    // 建编码器。
    let encoder = JSONEncoder()
    // 开 pretty print。
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    // 尝试编码。
    guard let data = try? encoder.encode(bindings) else {
      return "{ }"
    }
    // 转成 utf8 文本。
    return String(decoding: data, as: UTF8.self)
  }

  /// 把时间转成短文本。
  func timeText(for date: Date) -> String {
    // 走系统短时间格式。
    let formatter = DateFormatter()
    // 只保留时分秒。
    formatter.dateStyle = .none
    // 只保留时间。
    formatter.timeStyle = .medium
    // 返回结果。
    return formatter.string(from: date)
  }
}
