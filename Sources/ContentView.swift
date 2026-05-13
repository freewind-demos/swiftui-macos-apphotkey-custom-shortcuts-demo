import SwiftUI

/// Demo 主界面。
struct ContentView: View {
  /// 根 store。
  @StateObject private var store = HotkeyDemoStore()
  /// 根按键监听器。
  @State private var monitor: HotkeyEventMonitor?

  var body: some View {
    NavigationSplitView {
      // 左侧配置区。
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // 左侧标题。
          Text("Shortcut Bindings")
            .font(.largeTitle.bold())
          // 左侧说明。
          Text("点 Record 改绑定；点 Trigger 或直接按键，都只会统一显示你刚才激活了哪个动作。")
            .foregroundStyle(.secondary)

          HStack {
            // 恢复默认。
            Button("Reset Defaults") {
              store.resetToDefaults()
            }
            // 清日志。
            Button("Clear Log") {
              store.clearLog()
            }
          }

          ForEach(DemoShortcutAction.allCases) { action in
            ActionHotkeyCardView(
              action: action,
              hotkey: store.bindings.hotkey(for: action),
              onChange: { store.updateHotkey($0, for: action) },
              onTrigger: { store.trigger(action, source: "Button") },
              onRecordingChange: { store.setRecording($0) }
            )
          }
        }
        .padding(20)
      }
      .frame(minWidth: 430)
    } detail: {
      // 右侧结果区。
      ScrollView {
        VStack(alignment: .leading, spacing: 18) {
          // 最新结果卡片。
          VStack(alignment: .leading, spacing: 10) {
            Text("Latest Event")
              .font(.headline)
            Text(store.latestMessage)
              .font(.title2.weight(.semibold))
            Text("当前窗口获得焦点时，按左侧自定义快捷键即可触发。")
              .foregroundStyle(.secondary)
          }
          .padding(18)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color.accentColor.opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: 18))

          // 重复绑定提示。
          if !store.duplicateWarnings.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
              Text("Duplicate Bindings")
                .font(.headline)
              ForEach(store.duplicateWarnings, id: \.self) { warning in
                Text(warning)
                  .font(.callout.monospaced())
              }
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 18))
          }

          // 事件日志。
          VStack(alignment: .leading, spacing: 12) {
            Text("Event Log")
              .font(.headline)

            if store.eventLog.isEmpty {
              Text("还没有触发记录。")
                .foregroundStyle(.secondary)
            } else {
              ForEach(store.eventLog) { event in
                HStack(alignment: .top, spacing: 12) {
                  Text(store.timeText(for: event.happenedAt))
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                  VStack(alignment: .leading, spacing: 4) {
                    Text(event.action.title)
                      .font(.body.weight(.semibold))
                    Text("\(event.source) · \(event.hotkeyName)")
                      .font(.caption.monospaced())
                      .foregroundStyle(.secondary)
                  }
                  Spacer()
                }
                .padding(.vertical, 6)
                Divider()
              }
            }
          }
          .padding(18)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color(nsColor: .windowBackgroundColor))
          .overlay(
            RoundedRectangle(cornerRadius: 18)
              .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
          )
          .clipShape(RoundedRectangle(cornerRadius: 18))

          // JSON 预览。
          VStack(alignment: .leading, spacing: 12) {
            Text("Bindings JSON Preview")
              .font(.headline)
            Text(store.bindingsJSON)
              .font(.system(.body, design: .monospaced))
              .textSelection(.enabled)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .padding(18)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color(nsColor: .windowBackgroundColor))
          .overlay(
            RoundedRectangle(cornerRadius: 18)
              .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
          )
          .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(20)
      }
      .frame(minWidth: 540)
    }
    .navigationSplitViewStyle(.balanced)
    .frame(minWidth: 1180, minHeight: 760)
    .onAppear {
      // 安装根监听器。
      if monitor == nil {
        let newMonitor = HotkeyEventMonitor { event in
          store.handleKeyDown(event)
        }
        newMonitor.start()
        monitor = newMonitor
      }
    }
    .onDisappear {
      // 视图消失时清理监听。
      monitor?.stop()
      monitor = nil
    }
  }
}
