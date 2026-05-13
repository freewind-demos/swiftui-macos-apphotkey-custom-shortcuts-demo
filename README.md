# SwiftUI macOS AppHotkey Custom Shortcuts Demo

## 简介

这个 Demo 把 `freewind-paste` 里的 `AppHotkey` 思路单独抽出来，做成一个只演示“自定义快捷键 -> 触发虚拟动作”的 macOS SwiftUI 应用。

所有动作都不做真实业务，只会统一显示：你刚才激活了哪个动作。

## 快速开始

### 环境要求

- macOS 14 及以上
- Xcode 15 及以上
- XcodeGen：`brew install xcodegen`

### 运行

```bash
cd /Volumes/SN550-2T/freewind-demos/swiftui-macos-apphotkey-custom-shortcuts-demo

# 生成 Xcode 工程
xcodegen generate

# 直接编译
export DEVELOPER_DIR=/System/Volumes/Data/Applications/Xcode.app/Contents/Developer
xcodebuild \
  -project SwiftUIAppHotkeyCustomShortcutsDemo.xcodeproj \
  -scheme SwiftUIAppHotkeyCustomShortcutsDemo \
  -configuration Debug \
  -derivedDataPath .build/DerivedData \
  build

# 用 Xcode 打开
open SwiftUIAppHotkeyCustomShortcutsDemo.xcodeproj
```

也可以直接跑：

```bash
./dev.sh
```

## 注意事项

- 这里监听的是 app 前台窗口内的按键，不是系统级全局热键。
- 点击 `Record` 后，录制器会暂时接管按键；录制结束后才恢复动作监听。
- 可以把多个动作配成同一组快捷键；触发时会命中第一个匹配到的动作，所以右侧会给重复绑定提示。

## 教程

### 1. 关键概念

这个 Demo 保留了 3 个核心点：

1. `AppHotkey`
   用 `keyCode + modifiers` 表示一个快捷键，并负责把按键转成展示文案。
2. `DemoShortcutAction`
   预定义一组虚拟动作，比如 `Paste`、`Jump To Top`、`Delete Permanently`。
3. `HotkeyRecorderView`
   点击 `Record` 后，用本地事件监视器捕获下一次按键，写回当前动作的绑定。

### 2. demo 原理

流程是线性的：

1. 左侧给每个动作录制一个 `AppHotkey`
2. 根视图安装一个本地 `keyDown` monitor
3. monitor 逐个比对当前动作表
4. 命中后不做真实业务，只写一条“刚才激活了 xxx”日志

### 3. 关键代码解读

`Sources/AppHotkey.swift`

- `matches(_:)`：判断当前按键是否等于某个热键
- `displayName`：把 `⌘⇧V` 这种文案显示出来

`Sources/HotkeyRecorderView.swift`

- `toggleRecording()`：进入录制态
- `NSEvent.addLocalMonitorForEvents`：捕获下一次按键
- 录到后回调 `onChange`

`Sources/HotkeyDemoStore.swift`

- 保存整套动作绑定
- 接收真实按键事件
- 统一把动作转成右侧提示文案与日志

## 操作

1. 创建并进入目录

```bash
cd /Volumes/SN550-2T/freewind-demos
mkdir -p swiftui-macos-apphotkey-custom-shortcuts-demo
cd swiftui-macos-apphotkey-custom-shortcuts-demo
```

2. 初始化 git

```bash
git init
```

3. 生成工程并运行

```bash
xcodegen generate
open SwiftUIAppHotkeyCustomShortcutsDemo.xcodeproj
```

4. 在左侧点 `Record`，改某个动作的快捷键

5. 回到窗口里按刚配置的快捷键，右侧会显示触发结果
