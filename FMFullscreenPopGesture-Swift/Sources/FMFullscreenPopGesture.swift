// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import ObjectiveC

/// FMFullscreenPopGesture 主入口类
///
/// 用于初始化全屏滑动返回手势功能
///
/// ## 使用方法
/// 在 AppDelegate 的 `application(_:didFinishLaunchingWithOptions:)` 方法中调用：
/// ```swift
/// import FMFullscreenPopGesture
///
/// func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
///     FMFullscreenPopGesture.setup()
///     return true
/// }
/// ```
@objc public final class FMFullscreenPopGesture: NSObject {

    /// 私有初始化，防止外部创建实例
    private override init() {
        super.init()
    }

    /// 初始化全屏滑动返回手势功能
    ///
    /// 这个方法会设置 UIViewController 和 UINavigationController 的 Method Swizzling
    ///
    /// - Important: 必须在应用启动时调用一次，通常在 AppDelegate 的 `application(_:didFinishLaunchingWithOptions:)` 方法中
    public static func setup() {
        // 使用dispatch_once确保只执行一次
        struct Static {
            static let token: Void = {
                // 设置UIViewController的Method Swizzling
                FMFullscreenPopGesture.setupViewControllerSwizzling()

                // 设置UINavigationController的Method Swizzling
                FMFullscreenPopGesture.setupNavigationControllerSwizzling()
            }()
        }
        _ = Static.token
    }

    /// 设置 UIViewController 的 Method Swizzling
    private static func setupViewControllerSwizzling() {
        // 交换 viewWillAppear:
        if let originalMethod = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewWillAppear(_:))),
           let swizzledMethod = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.fm_viewWillAppear(_:))) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }

        // 交换 viewWillDisappear:
        if let originalMethod = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewWillDisappear(_:))),
           let swizzledMethod = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.fm_viewWillDisappear(_:))) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    /// 设置 UINavigationController 的 Method Swizzling
    private static func setupNavigationControllerSwizzling() {
        let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))
        let swizzledSelector = #selector(UINavigationController.fm_pushViewController(_:animated:))

        guard let originalMethod = class_getInstanceMethod(UINavigationController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UINavigationController.self, swizzledSelector) else {
            return
        }

        // 尝试添加方法（处理可能不存在的情况）
        let didAddMethod = class_addMethod(
            UINavigationController.self,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )

        if didAddMethod {
            // 方法不存在，替换为原始实现
            class_replaceMethod(
                UINavigationController.self,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            // 方法已存在，直接交换
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
