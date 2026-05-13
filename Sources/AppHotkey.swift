import AppKit
import Foundation

/// 热键值对象。
struct AppHotkey: Codable, Equatable, Hashable {
  /// macOS 虚拟键码。
  var keyCode: UInt32
  /// Carbon modifier bitmask。
  var modifiers: UInt32

  /// 演示默认值。
  static let `default` = Self(
    keyCode: 9,
    modifiers: 256 | 512
  )

  /// 把热键转成可读文案。
  var displayName: String {
    // 先拼修饰键。
    var parts: [String] = []
    // Command。
    if modifiers & 256 != 0 { parts.append("⌘") }
    // Shift。
    if modifiers & 512 != 0 { parts.append("⇧") }
    // Option。
    if modifiers & 2048 != 0 { parts.append("⌥") }
    // Control。
    if modifiers & 4096 != 0 { parts.append("⌃") }
    // 再拼主键。
    return parts.joined() + Self.keyName(for: keyCode)
  }

  /// 判断事件是否命中当前热键。
  func matches(_ event: NSEvent) -> Bool {
    // 键码一致。
    let sameKeyCode = keyCode == UInt32(event.keyCode)
    // 修饰键一致。
    let sameModifiers = modifiers == Self.carbonFlags(for: event.modifierFlags)
    // 两者都一致才算命中。
    return sameKeyCode && sameModifiers
  }

  /// 把 AppKit modifier flags 转成 Carbon bitmask。
  static func carbonFlags(for modifiers: NSEvent.ModifierFlags) -> UInt32 {
    // 从 0 开始累积。
    var flags: UInt32 = 0
    // Command。
    if modifiers.contains(.command) { flags |= 256 }
    // Shift。
    if modifiers.contains(.shift) { flags |= 512 }
    // Option。
    if modifiers.contains(.option) { flags |= 2048 }
    // Control。
    if modifiers.contains(.control) { flags |= 4096 }
    // 返回结果。
    return flags
  }

  /// 常见虚拟键码映射。
  private static func keyName(for keyCode: UInt32) -> String {
    // 只保留 demo 里常用的一组映射。
    let mapping: [UInt32: String] = [
      0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
      8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
      16: "Y", 17: "T", 31: "O", 32: "U", 34: "I", 35: "P", 36: "↩",
      37: "L", 38: "J", 40: "K", 45: "N", 46: "M", 48: "⇥", 49: "Space",
      51: "⌫", 53: "⎋", 76: "⌤", 123: "←", 124: "→", 125: "↓", 126: "↑"
    ]
    // 未命中时回退成原始键码。
    return mapping[keyCode] ?? "#\(keyCode)"
  }
}
