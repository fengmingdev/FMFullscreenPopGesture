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

// MARK: - Typealias

/// 对应Objective-C的 _FDViewControllerWillAppearInjectBlock
internal typealias ViewControllerWillAppearInjectBlock = (UIViewController, Bool) -> Void

// MARK: - Private Extension (对应 UIViewController+FDFullscreenPopGesturePrivate)

internal extension UIViewController {

    // MARK: - Associated Object Keys

    private struct AssociatedKeys {
        static var willAppearInjectBlock = "fm_willAppearInjectBlock"
    }

    // MARK: - Private Properties

    /// 对应Objective-C的 fd_willAppearInjectBlock
    var fm_willAppearInjectBlock: ViewControllerWillAppearInjectBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.willAppearInjectBlock) as? ViewControllerWillAppearInjectBlock
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.willAppearInjectBlock,
                newValue,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }

    // MARK: - Swizzled Methods

    /// 对应Objective-C的 - (void)fd_viewWillAppear:(BOOL)animated
    @objc internal dynamic func fm_viewWillAppear(_ animated: Bool) {
        // Forward to primary implementation.
        // 注意：由于方法已交换，这里调用的实际是原始的viewWillAppear:
        fm_viewWillAppear(animated)

        // 执行注入的block
        if let block = fm_willAppearInjectBlock {
            block(self, animated)
        }

        // IMPORTANT: 确保系统手势始终被禁用，使用我们的自定义手势
        if let navigationController = self.navigationController {
            let systemGesture = navigationController.interactivePopGestureRecognizer
            let customGesture = navigationController.fm_fullscreenPopGestureRecognizer

            print("🔧 [fm_viewWillAppear] \(type(of: self))")
            print("   System gesture: enabled=\(systemGesture?.isEnabled ?? false), delegate=\(String(describing: systemGesture?.delegate))")
            print("   Custom gesture: enabled=\(customGesture.isEnabled), delegate=\(String(describing: customGesture.delegate))")

            // CRITICAL: 禁用系统手势
            navigationController.interactivePopGestureRecognizer?.isEnabled = false

            // CRITICAL: 禁用所有附加到同一个view的其他pan手势（可能是系统的其他手势）
            if let gestureView = systemGesture?.view {
                print("   🔍 Checking all gestures on the gesture view:")
                for gesture in gestureView.gestureRecognizers ?? [] {
                    if let panGesture = gesture as? UIPanGestureRecognizer,
                       panGesture !== customGesture {
                        print("      Found pan gesture: \(panGesture), enabled=\(panGesture.isEnabled)")
                        if panGesture.isEnabled {
                            print("      ⚠️ Disabling this pan gesture!")
                            panGesture.isEnabled = false
                        }
                    }
                }
            }
        }
    }

    /// 对应Objective-C的 - (void)fd_viewWillDisappear:(BOOL)animated
    @objc internal dynamic func fm_viewWillDisappear(_ animated: Bool) {
        // Forward to primary implementation.
        // 注意：由于方法已交换，这里调用的实际是原始的viewWillDisappear:
        fm_viewWillDisappear(animated)

        // 延迟恢复导航栏
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let navigationController = self.navigationController,
                  let viewController = navigationController.viewControllers.last,
                  !viewController.fm_prefersNavigationBarHidden else {
                return
            }
            navigationController.setNavigationBarHidden(false, animated: false)
        }
    }
}

// MARK: - Public Extension (对应 UIViewController+FDFullscreenPopGesture)

public extension UIViewController {

    // MARK: - Associated Object Keys

    private struct PublicAssociatedKeys {
        static var interactivePopDisabled = "fm_interactivePopDisabled"
        static var prefersNavigationBarHidden = "fm_prefersNavigationBarHidden"
        static var interactivePopMaxAllowedInitialDistanceToLeftEdge = "fm_interactivePopMaxAllowedInitialDistanceToLeftEdge"
        static var shouldBeginBlock = "fm_shouldBeginBlock"
    }

    // MARK: - Public Properties

    /// Whether the interactive pop gesture is disabled when contained in a navigation stack.
    /// 对应Objective-C的 fd_interactivePopDisabled
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

    /// Indicate this view controller prefers its navigation bar hidden or not,
    /// checked when view controller based navigation bar's appearance is enabled.
    /// Default to NO, bars are more likely to show.
    /// 对应Objective-C的 fd_prefersNavigationBarHidden
    var fm_prefersNavigationBarHidden: Bool {
        get {
            return (objc_getAssociatedObject(self, &PublicAssociatedKeys.prefersNavigationBarHidden) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &PublicAssociatedKeys.prefersNavigationBarHidden,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// Max allowed initial distance to left edge when you begin the interactive pop gesture.
    /// 0 by default, which means it will ignore this limit.
    /// 对应Objective-C的 fd_interactivePopMaxAllowedInitialDistanceToLeftEdge
    var fm_interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat {
        get {
            #if CGFLOAT_IS_DOUBLE
            return (objc_getAssociatedObject(self, &PublicAssociatedKeys.interactivePopMaxAllowedInitialDistanceToLeftEdge) as? Double) ?? 0
            #else
            return (objc_getAssociatedObject(self, &PublicAssociatedKeys.interactivePopMaxAllowedInitialDistanceToLeftEdge) as? Float).map(CGFloat.init) ?? 0
            #endif
        }
        set {
            let distance = max(0, newValue)
            objc_setAssociatedObject(
                self,
                &PublicAssociatedKeys.interactivePopMaxAllowedInitialDistanceToLeftEdge,
                distance,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// 回调传值判断, false: 不允许返回，true：允许返回
    /// 对应Objective-C的 shouldBeginBlock
    var fm_shouldBeginBlock: (() -> Bool)? {
        get {
            return objc_getAssociatedObject(self, &PublicAssociatedKeys.shouldBeginBlock) as? (() -> Bool)
        }
        set {
            objc_setAssociatedObject(
                self,
                &PublicAssociatedKeys.shouldBeginBlock,
                newValue,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }
}
