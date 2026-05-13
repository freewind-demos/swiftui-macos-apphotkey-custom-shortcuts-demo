import AppKit
import SwiftUI

/// 录制单个动作的快捷键。
struct HotkeyRecorderView: View {
  /// 行标题。
  let title: String
  /// 当前热键。
  let hotkey: AppHotkey
  /// 是否要求必须带 modifier。
  let requiresModifier: Bool
  /// 热键变更回调。
  let onChange: (AppHotkey) -> Void
  /// 录制态变更回调。
  let onRecordingChange: (Bool) -> Void

  /// 当前是否在录制。
  @State private var isRecording = false
  /// 当前 monitor 句柄。
  @State private var monitor: Any?
  /// 底部反馈文案。
  @State private var feedbackText = ""
  /// 自动清空反馈的任务。
  @State private var feedbackTask: Task<Void, Never>?

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // 标题。
      Text(title)
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)

      HStack(spacing: 10) {
        // 录制中显示 listening，否则显示当前热键。
        Text(isRecording ? "Listening..." : hotkey.displayName)
          .font(.system(.body, design: .monospaced))
          .foregroundStyle(isRecording ? .secondary : .primary)
        Spacer()
        // 录制开关按钮。
        Button(isRecording ? "Cancel" : "Record") {
          toggleRecording()
        }
      }
      .padding(.vertical, 10)
      .padding(.horizontal, 12)
      .background(isRecording ? Color.accentColor.opacity(0.08) : Color(nsColor: .textBackgroundColor))
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(isRecording ? Color.accentColor : Color.secondary.opacity(0.2), lineWidth: 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 10))

      // 有反馈才显示。
      if !feedbackText.isEmpty {
        Text(feedbackText)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .onDisappear {
      // 视图消失时清理 monitor。
      stopRecording()
    }
  }

  /// 切换录制态。
  private func toggleRecording() {
    // 已在录制就取消。
    if isRecording {
      stopRecording()
      showFeedback("Recording cancelled.")
      return
    }

    // 进入录制态。
    isRecording = true
    // 通知外层暂停快捷键响应。
    onRecordingChange(true)
    // 给一条提示。
    feedbackText = requiresModifier
      ? "Press modifiers + key, Esc to cancel."
      : "Press key combo, Esc to cancel."

    // 抓下一次按键。
    monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
      // Escape 直接取消。
      if event.keyCode == 53 {
        stopRecording()
        showFeedback("Recording cancelled.")
        return nil
      }

      // 只保留这 4 类 modifier。
      let modifiers = event.modifierFlags.intersection([.command, .option, .control, .shift])

      // 若要求 modifier，但没按就拦住。
      if requiresModifier && modifiers.isEmpty {
        showFeedback("Modifiers required.")
        return nil
      }

      // 组装新热键。
      let newHotkey = AppHotkey(
        keyCode: UInt32(event.keyCode),
        modifiers: AppHotkey.carbonFlags(for: modifiers)
      )

      // 回写给外层。
      onChange(newHotkey)
      // 给反馈。
      showFeedback("Saved: \(newHotkey.displayName)")
      // 退出录制。
      stopRecording()
      // 吞掉事件。
      return nil
    }
  }

  /// 退出录制态。
  private func stopRecording() {
    // 先改布尔值。
    isRecording = false
    // 通知外层恢复监听。
    onRecordingChange(false)
    // 有 monitor 才移除。
    if let monitor {
      NSEvent.removeMonitor(monitor)
      self.monitor = nil
    }
  }

  /// 临时展示一条反馈。
  private func showFeedback(_ text: String) {
    // 取消旧任务。
    feedbackTask?.cancel()
    // 设置文案。
    feedbackText = text
    // 启一个自动清空任务。
    feedbackTask = Task { @MainActor in
      // 等一小会儿。
      try? await Task.sleep(for: .seconds(1.2))
      // 被取消就直接停。
      guard !Task.isCancelled else {
        return
      }
      // 只清当前这条。
      if feedbackText == text {
        feedbackText = ""
      }
    }
  }
}
