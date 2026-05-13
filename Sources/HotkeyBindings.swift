import Foundation

/// 一组虚拟动作。
enum DemoShortcutAction: String, CaseIterable, Codable, Identifiable {
  /// 关闭面板。
  case closePopup
  /// 聚焦列表。
  case focusList
  /// 普通粘贴。
  case paste
  /// 原生粘贴。
  case nativePaste
  /// 上一个。
  case focusPrevious
  /// 下一个。
  case focusNext
  /// 向上扩选。
  case expandPrevious
  /// 向下扩选。
  case expandNext
  /// 跳顶部。
  case jumpToTop
  /// 跳底部。
  case jumpToBottom
  /// 选区上移。
  case moveSelectionUp
  /// 选区下移。
  case moveSelectionDown
  /// 删除。
  case deleteSelection
  /// 永久删除。
  case deleteSelectionPermanently

  /// SwiftUI `ForEach` 标识。
  var id: String { rawValue }

  /// 面向用户的标题。
  var title: String {
    switch self {
    case .closePopup:
      return "Close Popup"
    case .focusList:
      return "Focus List"
    case .paste:
      return "Paste"
    case .nativePaste:
      return "Native Paste"
    case .focusPrevious:
      return "Focus Previous"
    case .focusNext:
      return "Focus Next"
    case .expandPrevious:
      return "Expand Previous"
    case .expandNext:
      return "Expand Next"
    case .jumpToTop:
      return "Jump To Top"
    case .jumpToBottom:
      return "Jump To Bottom"
    case .moveSelectionUp:
      return "Move Selection Up"
    case .moveSelectionDown:
      return "Move Selection Down"
    case .deleteSelection:
      return "Delete Selection"
    case .deleteSelectionPermanently:
      return "Delete Permanently"
    }
  }

  /// 简短说明。
  var note: String {
    switch self {
    case .closePopup:
      return "演示关闭类动作。"
    case .focusList:
      return "演示切焦点动作。"
    case .paste:
      return "演示主确认动作。"
    case .nativePaste:
      return "演示带变体的确认动作。"
    case .focusPrevious:
      return "演示向前导航。"
    case .focusNext:
      return "演示向后导航。"
    case .expandPrevious:
      return "演示范围扩选。"
    case .expandNext:
      return "演示范围扩选。"
    case .jumpToTop:
      return "演示跳到边界。"
    case .jumpToBottom:
      return "演示跳到边界。"
    case .moveSelectionUp:
      return "演示块移动。"
    case .moveSelectionDown:
      return "演示块移动。"
    case .deleteSelection:
      return "演示危险动作。"
    case .deleteSelectionPermanently:
      return "演示更危险动作。"
    }
  }
}

/// 动作到热键的绑定表。
struct DemoHotkeyBindings: Codable, Equatable {
  /// 关闭面板。
  var closePopup: AppHotkey
  /// 聚焦列表。
  var focusList: AppHotkey
  /// 普通粘贴。
  var paste: AppHotkey
  /// 原生粘贴。
  var nativePaste: AppHotkey
  /// 上一个。
  var focusPrevious: AppHotkey
  /// 下一个。
  var focusNext: AppHotkey
  /// 向上扩选。
  var expandPrevious: AppHotkey
  /// 向下扩选。
  var expandNext: AppHotkey
  /// 跳顶部。
  var jumpToTop: AppHotkey
  /// 跳底部。
  var jumpToBottom: AppHotkey
  /// 选区上移。
  var moveSelectionUp: AppHotkey
  /// 选区下移。
  var moveSelectionDown: AppHotkey
  /// 删除。
  var deleteSelection: AppHotkey
  /// 永久删除。
  var deleteSelectionPermanently: AppHotkey

  /// 默认快捷键。
  static let `default` = Self(
    closePopup: .init(keyCode: 53, modifiers: 0),
    focusList: .init(keyCode: 48, modifiers: 0),
    paste: .init(keyCode: 36, modifiers: 0),
    nativePaste: .init(keyCode: 36, modifiers: 512),
    focusPrevious: .init(keyCode: 126, modifiers: 0),
    focusNext: .init(keyCode: 125, modifiers: 0),
    expandPrevious: .init(keyCode: 126, modifiers: 512),
    expandNext: .init(keyCode: 125, modifiers: 512),
    jumpToTop: .init(keyCode: 126, modifiers: 256),
    jumpToBottom: .init(keyCode: 125, modifiers: 256),
    moveSelectionUp: .init(keyCode: 126, modifiers: 512 | 2048),
    moveSelectionDown: .init(keyCode: 125, modifiers: 512 | 2048),
    deleteSelection: .init(keyCode: 51, modifiers: 0),
    deleteSelectionPermanently: .init(keyCode: 51, modifiers: 256)
  )

  /// 读某个动作的热键。
  func hotkey(for action: DemoShortcutAction) -> AppHotkey {
    switch action {
    case .closePopup:
      return closePopup
    case .focusList:
      return focusList
    case .paste:
      return paste
    case .nativePaste:
      return nativePaste
    case .focusPrevious:
      return focusPrevious
    case .focusNext:
      return focusNext
    case .expandPrevious:
      return expandPrevious
    case .expandNext:
      return expandNext
    case .jumpToTop:
      return jumpToTop
    case .jumpToBottom:
      return jumpToBottom
    case .moveSelectionUp:
      return moveSelectionUp
    case .moveSelectionDown:
      return moveSelectionDown
    case .deleteSelection:
      return deleteSelection
    case .deleteSelectionPermanently:
      return deleteSelectionPermanently
    }
  }

  /// 改某个动作的热键。
  mutating func set(_ hotkey: AppHotkey, for action: DemoShortcutAction) {
    switch action {
    case .closePopup:
      closePopup = hotkey
    case .focusList:
      focusList = hotkey
    case .paste:
      paste = hotkey
    case .nativePaste:
      nativePaste = hotkey
    case .focusPrevious:
      focusPrevious = hotkey
    case .focusNext:
      focusNext = hotkey
    case .expandPrevious:
      expandPrevious = hotkey
    case .expandNext:
      expandNext = hotkey
    case .jumpToTop:
      jumpToTop = hotkey
    case .jumpToBottom:
      jumpToBottom = hotkey
    case .moveSelectionUp:
      moveSelectionUp = hotkey
    case .moveSelectionDown:
      moveSelectionDown = hotkey
    case .deleteSelection:
      deleteSelection = hotkey
    case .deleteSelectionPermanently:
      deleteSelectionPermanently = hotkey
    }
  }
}
