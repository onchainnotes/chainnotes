# Launch Screen Assets（启动 Logo）

本目录用于 **iOS 原生启动屏 Logo**。替换下方文件即可更换启动时显示的 Logo。

## 替换步骤

1. **准备一张 Logo 图**（PNG，建议透明底）
   - 推荐尺寸：**618×618** 或 **1242×1242**（正方形，@3x）
   - 或任意比例，系统会按比例缩放并居中显示

2. **替换文件**
   - 将你的图片重命名为 `LaunchImage@3x.png`
   - 覆盖本目录下的 `LaunchImage@3x.png`

3. **在 Xcode 中刷新（可选）**
   - 若未自动更新，可执行：`open ios/Runner.xcworkspace`
   - 在左侧选中 `Runner/Assets.xcassets/LaunchImage`，确认图片已更新

## 说明

- 当前仅使用 **@3x** 一张图，系统会自动缩放适配各分辨率。
- 启动屏背景色已设为与 App 内启动页一致的浅绿色（#f0fdf4），Logo 为居中、等比例缩放（scaleAspectFit）。