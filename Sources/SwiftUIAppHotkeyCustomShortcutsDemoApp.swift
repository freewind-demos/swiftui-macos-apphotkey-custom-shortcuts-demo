import SwiftUI

/// App 入口。
@main
struct SwiftUIAppHotkeyCustomShortcutsDemoApp: App {
  var body: some Scene {
    // 单窗口 demo。
    Window("AppHotkey Custom Shortcuts Demo", id: "main") {
      ContentView()
    }
    .defaultSize(width: 1280, height: 820)
  }
}
