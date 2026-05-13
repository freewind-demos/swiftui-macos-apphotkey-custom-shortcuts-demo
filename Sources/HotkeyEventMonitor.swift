import AppKit
import Foundation

/// 根视图级别的按键监听器。
final class HotkeyEventMonitor {
  /// AppKit monitor 句柄。
  private var monitor: Any?
  /// 按键回调。
  private let onKeyDown: (NSEvent) -> Bool

  /// 注入按键处理闭包。
  init(onKeyDown: @escaping (NSEvent) -> Bool) {
    // 收下闭包。
    self.onKeyDown = onKeyDown
  }

  /// 启动监听。
  func start() {
    // 避免重复安装。
    guard monitor == nil else {
      return
    }
    // 安装本地 `keyDown` monitor。
    monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [onKeyDown] event in
      // 命中就吞掉事件。
      if onKeyDown(event) {
        return nil
      }
      // 未命中就继续传递。
      return event
    }
  }

  /// 停止监听。
  func stop() {
    // 有句柄才移除。
    if let monitor {
      NSEvent.removeMonitor(monitor)
      self.monitor = nil
    }
  }

  deinit {
    // 析构时兜底清理。
    stop()
  }
}
