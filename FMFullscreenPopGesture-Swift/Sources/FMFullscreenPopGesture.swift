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
                UIViewController.fm_setupMethodSwizzling()

                // 设置UINavigationController的Method Swizzling
                UINavigationController.fm_setupMethodSwizzling()
            }()
        }
        _ = Static.token
    }
}
