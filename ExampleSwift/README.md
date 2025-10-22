# ExampleSwift - FMFullscreenPopGesture Swift 示例项目

这是 FMFullscreenPopGesture Swift 版本的示例项目，演示了如何使用全屏滑动返回手势的各种功能。

## 📋 示例场景

本示例项目包含以下6个演示场景：

### 1. 基础示例
- **功能**：演示默认的全屏滑动返回效果
- **特点**：无需任何配置，自动生效
- **体验**：从屏幕任意位置向右滑动即可返回

### 2. 禁用返回手势
- **功能**：演示如何禁用滑动返回
- **代码**：`fm_interactivePopDisabled = true`
- **场景**：适用于编辑页面、表单页面等不希望误触返回的场景

### 3. 限制触发区域
- **功能**：演示如何限制手势触发区域
- **代码**：`fm_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50`
- **场景**：适用于有左侧滑动菜单或其他左侧手势冲突的场景

### 4. 自定义返回逻辑
- **功能**：演示如何使用闭包控制返回行为
- **代码**：`fm_shouldBeginBlock = { [weak self] in ... }`
- **场景**：适用于有未保存内容、需要二次确认的场景
- **交互**：在文本框输入内容后尝试返回，会弹出保存提示

### 5. 隐藏导航栏
- **功能**：演示导航栏隐藏时仍支持滑动返回
- **代码**：`fm_prefersNavigationBarHidden = true`
- **场景**：适用于全屏展示、图片查看等场景

### 6. 导航栏切换
- **功能**：演示不同页面间导航栏显示/隐藏的平滑切换
- **场景**：适用于需要在显示和隐藏导航栏的页面间切换的场景

## 🚀 运行示例

### 方式一：使用 CocoaPods（推荐）

```bash
cd ExampleSwift
pod install
open ExampleSwift.xcworkspace
```

### 方式二：使用 Swift Package Manager

1. 在 Xcode 中打开 `ExampleSwift.xcodeproj`
2. 选择 `File` → `Add Packages...`
3. 输入本地路径或仓库地址
4. 添加 `FMFullscreenPopGesture` 包

## 📁 项目结构

```
ExampleSwift/
├── ExampleSwift/
│   ├── AppDelegate.swift           # 应用委托，包含初始化代码
│   ├── SceneDelegate.swift         # Scene 委托
│   ├── ViewController.swift        # 主视图控制器，包含所有示例场景
│   ├── Assets.xcassets/           # 资源文件
│   └── Info.plist                 # 配置文件
├── ExampleSwift.xcodeproj/        # Xcode 项目文件
├── Podfile                        # CocoaPods 配置
└── README.md                      # 本文件
```

## 💡 代码示例

### 初始化（AppDelegate.swift）

```swift
import UIKit
import FMFullscreenPopGesture

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化 FMFullscreenPopGesture (重要！)
        FMFullscreenPopGesture.setup()

        return true
    }
}
```

### 禁用返回手势

```swift
class DisabledGestureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 禁用滑动返回
        fm_interactivePopDisabled = true
    }
}
```

### 限制触发区域

```swift
class LimitedTriggerAreaViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 只允许在左边 50pt 内触发返回手势
        fm_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50
    }
}
```

### 自定义返回逻辑

```swift
class CustomLogicViewController: UIViewController {

    private var hasUnsavedChanges = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置自定义返回逻辑
        fm_shouldBeginBlock = { [weak self] in
            guard let self = self else { return true }

            if self.hasUnsavedChanges {
                self.showSaveAlert()
                return false  // 不允许返回
            }
            return true  // 允许返回
        }
    }

    private func showSaveAlert() {
        let alert = UIAlertController(
            title: "未保存的内容",
            message: "您有未保存的内容，确定要离开吗？",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "放弃", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
```

### 隐藏导航栏

```swift
class HiddenNavigationBarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏导航栏（仍然支持滑动返回）
        fm_prefersNavigationBarHidden = true
    }
}
```

## 🎯 学习要点

1. **初始化时机**：必须在 `AppDelegate` 的 `application(_:didFinishLaunchingWithOptions:)` 方法中调用 `FMFullscreenPopGesture.setup()`

2. **API 前缀**：所有 API 都使用 `fm_` 前缀

3. **内存管理**：使用闭包时要注意循环引用，使用 `[weak self]` 捕获列表

4. **导航栏管理**：每个 ViewController 可以独立控制导航栏的显示/隐藏

5. **手势冲突**：如果有其他手势，可以通过限制触发区域或自定义逻辑来避免冲突

## 🔍 调试技巧

1. **检查初始化**：确保在 `AppDelegate` 中调用了 `FMFullscreenPopGesture.setup()`

2. **检查导入**：确保在需要使用的文件中导入了 `import FMFullscreenPopGesture`

3. **检查导航控制器**：确保 ViewController 在 `UINavigationController` 的导航栈中

4. **检查禁用状态**：确认没有意外设置 `fm_interactivePopDisabled = true`

## 📚 相关文档

- [FMFullscreenPopGesture 主文档](../README.md)
- [Swift 版本详细文档](../FMFullscreenPopGesture-Swift/README.md)
- [项目结构说明](../FMFullscreenPopGesture-Swift/PROJECT_STRUCTURE.md)

## 📄 许可证

本示例项目采用 MIT 许可证。

---

**Made with ❤️ by fengming**
