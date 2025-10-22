# FMFullscreenPopGesture (Swift Version)

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/fengmingdev/FMFullscreenPopGesture)
[![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B-lightgrey.svg)](https://github.com/fengmingdev/FMFullscreenPopGesture)
[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/fengmingdev/FMFullscreenPopGesture/blob/master/LICENSE)

FMFullscreenPopGesture 是一个 UINavigationController 的扩展库，用于在 iOS 13+ 系统中启用**全屏滑动返回手势**。

这是对原 Objective-C 版本的 **Swift 翻译式重构**，保持 100% API 兼容性，同时利用 Swift 语言特性提供更好的类型安全和开发体验。

## 📖 原版项目

本项目是对 [forkingdog/FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture) 的改进版本的 Swift 重写。

## ✨ 特性

- ✅ **全屏滑动返回**：从屏幕任意位置滑动返回，而非仅限边缘
- ✅ **按视图控制器控制**：每个 ViewController 可独立配置
- ✅ **自定义判断逻辑**：支持通过闭包动态控制返回行为
- ✅ **限制触发区域**：可设置手势触发的最大左边距
- ✅ **导航栏自动管理**：支持视图控制器级别的导航栏显示/隐藏
- ✅ **RTL布局支持**：完美支持从右到左的语言布局
- ✅ **iOS 13.0+**：最低支持 iOS 13.0
- ✅ **Swift Package Manager**：原生支持 SPM
- ✅ **CocoaPods**：传统 CocoaPods 支持

## 📦 安装

### Swift Package Manager (推荐)

在 Xcode 中：
1. 选择 `File` → `Add Packages...`
2. 输入仓库地址：`https://github.com/fengmingdev/FMFullscreenPopGesture.git`
3. 选择版本 `2.0.0` 或更高
4. 点击 `Add Package`

或在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/fengmingdev/FMFullscreenPopGesture.git", from: "2.0.0")
]
```

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'FMFullscreenPopGesture', '~> 2.0'
```

然后运行：

```bash
pod install
```

## 🚀 使用方法

### 1. 初始化

在 `AppDelegate.swift` 中导入并初始化：

```swift
import UIKit
import FMFullscreenPopGesture

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化 FMFullscreenPopGesture（重要！）
        FMFullscreenPopGesture.setup()

        return true
    }
}
```

### 2. 基础使用（自动生效）

一旦完成初始化，所有 `UINavigationController` 都会**自动支持全屏滑动返回**，无需额外代码！

```swift
import UIKit

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 什么都不需要做，已经支持全屏滑动返回了！
    }
}
```

### 3. 禁用返回手势

```swift
import FMFullscreenPopGesture

class EditViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 完全禁用返回手势
        fm_interactivePopDisabled = true
    }
}
```

### 4. 限制触发区域

```swift
import FMFullscreenPopGesture

class CustomViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 只允许在左边 50pt 内触发返回手势
        fm_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50
    }
}
```

### 5. 自定义返回逻辑（推荐）

```swift
import FMFullscreenPopGesture

class FormViewController: UIViewController {

    private var hasUnsavedChanges = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // 使用闭包灵活控制返回行为
        fm_shouldBeginBlock = { [weak self] in
            guard let self = self else { return true }

            // 有未保存的修改时，显示提示
            if self.hasUnsavedChanges {
                self.showSaveAlert()
                return false  // 不允许返回
            }
            return true  // 允许返回
        }
    }

    private func showSaveAlert() {
        let alert = UIAlertController(
            title: "未保存",
            message: "您有未保存的修改，确定要离开吗？",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "离开", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
```

### 6. 隐藏导航栏

```swift
import FMFullscreenPopGesture

class FullscreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏导航栏（仍然支持滑动返回）
        fm_prefersNavigationBarHidden = true
    }
}
```

### 7. 禁用基于视图控制器的导航栏管理

```swift
import FMFullscreenPopGesture

class MyNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 禁用自动导航栏管理，使用全局设置
        fm_viewControllerBasedNavigationBarAppearanceEnabled = false
    }
}
```

## 📚 API 文档

### UIViewController 扩展

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `fm_interactivePopDisabled` | `Bool` | `false` | 是否禁用滑动返回手势 |
| `fm_prefersNavigationBarHidden` | `Bool` | `false` | 是否隐藏导航栏 |
| `fm_interactivePopMaxAllowedInitialDistanceToLeftEdge` | `CGFloat` | `0` | 手势触发的最大左边距（0表示无限制） |
| `fm_shouldBeginBlock` | `(() -> Bool)?` | `nil` | 自定义返回手势判断逻辑<br>`true`：允许返回<br>`false`：不允许返回 |

### UINavigationController 扩展

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `fm_fullscreenPopGestureRecognizer` | `UIPanGestureRecognizer` | - | 全屏滑动返回手势识别器（只读） |
| `fm_viewControllerBasedNavigationBarAppearanceEnabled` | `Bool` | `true` | 是否启用基于视图控制器的导航栏外观管理 |

## 🔄 从 Objective-C 版本迁移

### API 对比

| Objective-C | Swift | 说明 |
|-------------|-------|------|
| `fd_fullscreenPopGestureRecognizer` | `fm_fullscreenPopGestureRecognizer` | 前缀从 `fd_` 改为 `fm_` |
| `fd_viewControllerBasedNavigationBarAppearanceEnabled` | `fm_viewControllerBasedNavigationBarAppearanceEnabled` | 前缀从 `fd_` 改为 `fm_` |
| `fd_interactivePopDisabled` | `fm_interactivePopDisabled` | 前缀从 `fd_` 改为 `fm_` |
| `fd_prefersNavigationBarHidden` | `fm_prefersNavigationBarHidden` | 前缀从 `fd_` 改为 `fm_` |
| `fd_interactivePopMaxAllowedInitialDistanceToLeftEdge` | `fm_interactivePopMaxAllowedInitialDistanceToLeftEdge` | 前缀从 `fd_` 改为 `fm_` |
| `shouldBeginBlock` | `fm_shouldBeginBlock` | 添加了 `fm_` 前缀 |

### 迁移步骤

1. **更新依赖**
   ```ruby
   # Podfile
   # 注释掉旧版本
   # pod 'FMFullscreenPopGesture', '~> 1.1'

   # 使用新版本
   pod 'FMFullscreenPopGesture', '~> 2.0'
   ```

2. **初始化（新增）**
   ```swift
   // AppDelegate.swift
   import FMFullscreenPopGesture

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       FMFullscreenPopGesture.setup()  // 新增这一行
       return true
   }
   ```

3. **批量替换 API**
   - 使用 Xcode 的 Find & Replace 功能
   - 将所有 `fd_` 替换为 `fm_`
   - 将 `shouldBeginBlock` 替换为 `fm_shouldBeginBlock`

4. **Block 语法转换**
   ```objc
   // Objective-C
   __weak typeof(self) weakSelf = self;
   self.shouldBeginBlock = ^BOOL{
       __strong typeof(weakSelf) strongSelf = weakSelf;
       return !strongSelf.hasChanges;
   };
   ```

   ```swift
   // Swift
   fm_shouldBeginBlock = { [weak self] in
       guard let self = self else { return true }
       return !self.hasChanges
   }
   ```

## 🎯 实现原理

### 核心技术

1. **Method Swizzling**
   - 交换 `UIViewController` 的 `viewWillAppear:` 和 `viewWillDisappear:` 方法
   - 交换 `UINavigationController` 的 `pushViewController:animated:` 方法

2. **Associated Objects**
   - 使用 `objc_getAssociatedObject` 和 `objc_setAssociatedObject` 为 Extension 添加属性

3. **手势代理**
   - 创建自定义 `UIPanGestureRecognizer`
   - 通过 KVC 获取系统手势的内部 target 和 action
   - 复用系统的交互式转场动画

4. **导航栏管理**
   - 在 `viewWillAppear:` 中注入导航栏显示/隐藏逻辑
   - 支持视图控制器级别的导航栏外观控制

### 与 Objective-C 版本的区别

| 特性 | Objective-C | Swift |
|------|-------------|-------|
| Extension 语法 | Category | Extension |
| 闭包语法 | Block | Closure |
| 类型安全 | 弱类型 | 强类型 |
| 可选值处理 | `nil` 检查 | `Optional` |
| 初始化方式 | `+load` 方法 | 手动调用 `setup()` |

## ⚙️ 系统要求

- **iOS**: 13.0+
- **Swift**: 5.5+
- **Xcode**: 13.0+

## 📄 许可证

FMFullscreenPopGesture 采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- 原始项目：[forkingdog/FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)
- 作者：[@fengming](https://github.com/fengmingdev)

## 📞 联系方式

如有问题或建议，请：
- 提交 [Issue](https://github.com/fengmingdev/FMFullscreenPopGesture/issues)
- 发送 Pull Request

## 🔗 相关链接

- [Objective-C 版本](https://github.com/fengmingdev/FMFullscreenPopGesture)
- [示例项目](./Example)
- [更新日志](CHANGELOG.md)

---

**Made with ❤️ by fengming**
