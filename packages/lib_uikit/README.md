# lib_uikit

UI组件库，提供可复用的UI组件和样式。

## 功能

- **按钮组件**：主要按钮、次要按钮、图标按钮
- **输入框组件**：文本输入框、密码输入框
- **卡片组件**：基础卡片、操作卡片
- **加载组件**：加载指示器、空状态、错误状态
- **主题配置**：应用主题、颜色、文本样式

## 使用

在主项目的 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  lib_uikit:
    path: packages/lib_uikit
```

然后在代码中导入：

```dart
import 'package:lib_uikit/lib_uikit.dart';
```

## 示例

```dart
// 使用主要按钮
PrimaryButton(
  text: '登录',
  onPressed: () {
    // 处理点击
  },
)

// 使用文本输入框
TextInputField(
  labelText: '邮箱',
  hintText: '请输入邮箱',
  prefixIcon: Icons.email,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱';
    }
    return null;
  },
)
```
