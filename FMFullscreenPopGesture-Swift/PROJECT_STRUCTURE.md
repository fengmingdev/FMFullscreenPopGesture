# FMFullscreenPopGesture Swift 版本 - 项目结构

## 📁 目录结构

```
FMFullscreenPopGesture-Swift/
├── Sources/                                    # 源代码目录
│   └── FMFullscreenPopGesture/
│       ├── FMFullscreenPopGesture.swift                        # 入口文件和初始化
│       ├── UINavigationController+FMFullscreenPopGesture.swift # UINavigationController扩展
│       ├── UIViewController+FMFullscreenPopGesture.swift       # UIViewController扩展
│       └── FMFullscreenPopGestureRecognizerDelegate.swift      # 手势代理类
│
├── Example/                                    # 示例项目
│   ├── AppDelegate.swift                      # 应用委托
│   ├── ViewController.swift                   # 主视图控制器（含5个示例场景）
│   └── FMListenViewController.swift           # 自定义返回逻辑示例
│
├── Tests/                                      # 单元测试
│   └── FMFullscreenPopGestureTests/
│       └── FMFullscreenPopGestureTests.swift  # 测试用例
│
├── Package.swift                               # Swift Package Manager 配置
├── FMFullscreenPopGesture.podspec             # CocoaPods 规范文件
├── README.md                                   # 项目说明文档
├── CHANGELOG.md                                # 更新日志
├── LICENSE                                     # MIT 许可证
└── .gitignore                                  # Git 忽略文件

```

## 📄 核心文件说明

### 1. FMFullscreenPopGesture.swift
**职责**: 项目入口和初始化

**主要内容**:
- `FMFullscreenPopGesture` 类：提供 `setup()` 静态方法用于初始化
- 自动设置 Method Swizzling
- 替代 Objective-C 的 `+load` 方法

**关键代码**:
```swift
public static func setup() {
    UIViewController.setupMethodSwizzling()
    UINavigationController.setupMethodSwizzling()
}
```

---

### 2. UINavigationController+FMFullscreenPopGesture.swift
**职责**: UINavigationController 的全屏滑动返回扩展

**主要功能**:
- ✅ 添加全屏滑动返回手势识别器
- ✅ 复用系统的交互式转场动画
- ✅ 管理导航栏的显示/隐藏
- ✅ Method Swizzling: `pushViewController:animated:`

**公开API**:
- `fm_fullscreenPopGestureRecognizer: UIPanGestureRecognizer` (只读)
- `fm_viewControllerBasedNavigationBarAppearanceEnabled: Bool`

**技术要点**:
- 通过 KVC 访问系统手势的私有属性 `targets`
- 获取内部 target 和 action: `handleNavigationTransition:`
- 禁用系统的 `interactivePopGestureRecognizer`

---

### 3. UIViewController+FMFullscreenPopGesture.swift
**职责**: UIViewController 的控制属性扩展

**主要功能**:
- ✅ 提供视图控制器级别的返回手势控制
- ✅ 导航栏显示/隐藏控制
- ✅ 自定义返回逻辑支持
- ✅ Method Swizzling: `viewWillAppear:` 和 `viewWillDisappear:`

**公开API**:
- `fm_interactivePopDisabled: Bool`
- `fm_prefersNavigationBarHidden: Bool`
- `fm_interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat`
- `fm_shouldBeginBlock: (() -> Bool)?`

**内部API**:
- `fm_willAppearInjectBlock: ViewControllerWillAppearInjectBlock?` (internal)

---

### 4. FMFullscreenPopGestureRecognizerDelegate.swift
**职责**: 手势识别器的代理

**主要功能**:
- ✅ 实现 `UIGestureRecognizerDelegate`
- ✅ 决定手势是否应该开始
- ✅ 执行6层检查逻辑

**检查逻辑顺序**:
1. 栈深度检查（>= 2）
2. 当前VC是否禁用返回
3. 手势起点位置检查
4. 导航控制器是否正在转场
5. 滑动方向检查（支持RTL）
6. 调用自定义block

---

## 🔄 对比：Objective-C vs Swift

| 特性 | Objective-C版本 | Swift版本 |
|------|----------------|----------|
| **文件数量** | 2个文件 (.h + .m) | 4个Swift文件 |
| **代码行数** | ~300行 | ~500行 (含注释和文档) |
| **初始化方式** | `+load` 自动执行 | 需手动调用 `FMFullscreenPopGesture.setup()` |
| **API前缀** | `fd_` | `fm_` |
| **闭包语法** | Block | Swift Closure |
| **类型安全** | 运行时检查 | 编译时检查 |
| **可选值** | `nil` 检查 | `Optional` |

---

## 🛠 技术实现

### Method Swizzling

**Objective-C版本**:
```objc
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(fd_viewWillAppear:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}
```

**Swift版本**:
```swift
static func setupMethodSwizzling() {
    struct Static {
        static var token: Void = {
            swizzleMethod(
                originalSelector: #selector(UIViewController.viewWillAppear(_:)),
                swizzledSelector: #selector(UIViewController.fm_viewWillAppear(_:))
            )
        }()
    }
    _ = Static.token
}
```

### Associated Objects

**Objective-C版本**:
```objc
- (BOOL)fd_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(fd_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
```

**Swift版本**:
```swift
var fm_interactivePopDisabled: Bool {
    get {
        return (objc_getAssociatedObject(self, &PublicAssociatedKeys.interactivePopDisabled) as? Bool) ?? false
    }
    set {
        objc_setAssociatedObject(
            self,
            &PublicAssociatedKeys.interactivePopDisabled,
            newValue,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}
```

---

## 📊 代码质量指标

| 指标 | 数值 |
|------|------|
| **Swift文件数** | 4 |
| **总代码行数** | ~500行 |
| **注释覆盖率** | 40% |
| **单元测试数** | 10个测试用例 |
| **支持的iOS版本** | iOS 13.0+ |
| **Swift版本** | 5.5+ |

---

## 🎯 迁移检查清单

从 Objective-C 版本迁移到 Swift 版本时，请确认以下步骤：

- [ ] 更新 Podfile 或 Package.swift 依赖
- [ ] 在 AppDelegate 中调用 `FMFullscreenPopGesture.setup()`
- [ ] 批量替换 API 前缀：`fd_` → `fm_`
- [ ] 转换 Block 语法为 Swift Closure
- [ ] 删除 Objective-C 桥接头文件（如有）
- [ ] 运行测试确保功能正常
- [ ] 验证边缘情况：RTL布局、导航栏隐藏等

---

## 🔗 相关资源

- [README.md](README.md) - 完整使用文档
- [CHANGELOG.md](CHANGELOG.md) - 版本更新历史
- [Example/](Example/) - 示例代码
- [Tests/](Tests/) - 单元测试

---

**最后更新**: 2024-01-XX
