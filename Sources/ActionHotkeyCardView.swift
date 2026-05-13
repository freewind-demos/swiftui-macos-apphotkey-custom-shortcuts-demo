import SwiftUI

/// 单个动作的配置卡片。
struct ActionHotkeyCardView: View {
  /// 当前动作。
  let action: DemoShortcutAction
  /// 当前热键。
  let hotkey: AppHotkey
  /// 录制后回写。
  let onChange: (AppHotkey) -> Void
  /// 手动模拟触发。
  let onTrigger: () -> Void
  /// 录制态变更。
  let onRecordingChange: (Bool) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // 标题。
      Text(action.title)
        .font(.headline)
      // 说明。
      Text(action.note)
        .font(.subheadline)
        .foregroundStyle(.secondary)
      // 录制器。
      HotkeyRecorderView(
        title: "Hotkey",
        hotkey: hotkey,
        requiresModifier: false,
        onChange: onChange,
        onRecordingChange: onRecordingChange
      )
      // 底部操作行。
      HStack {
        // 当前文案。
        Text("Current: \(hotkey.displayName)")
          .font(.caption.monospaced())
          .foregroundStyle(.secondary)
        Spacer()
        // 手动模拟按钮。
        Button("Trigger") {
          onTrigger()
        }
      }
    }
    .padding(16)
    .background(Color(nsColor: .windowBackgroundColor))
    .overlay(
      RoundedRectangle(cornerRadius: 14)
        .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
    )
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}
