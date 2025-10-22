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

/// "UINavigationController+FMFullscreenPopGesture" extends UINavigationController's swipe-
/// to-pop behavior in iOS 7+ by supporting fullscreen pan gesture. Instead of
/// screen edge, you can now swipe from any place on the screen and the onboard
/// interactive pop transition works seamlessly.
///
/// Adding the implementation file of this category to your target will
/// automatically patch UINavigationController with this feature.
public extension UINavigationController {

    // MARK: - Associated Object Keys

    private struct AssociatedKeys {
        static var popGestureRecognizerDelegate = "fm_popGestureRecognizerDelegate"
        static var fullscreenPopGestureRecognizer = "fm_fullscreenPopGestureRecognizer"
        static var viewControllerBasedNavigationBarAppearanceEnabled = "fm_viewControllerBasedNavigationBarAppearanceEnabled"
    }

    // MARK: - Public Properties

    /// The gesture recognizer that actually handles interactive pop.
    /// 对应Objective-C的 fd_fullscreenPopGestureRecognizer
    var fm_fullscreenPopGestureRecognizer: UIPanGestureRecognizer {
        // 延迟初始化
        if let recognizer = objc_getAssociatedObject(self, &AssociatedKeys.fullscreenPopGestureRecognizer) as? UIPanGestureRecognizer {
            return recognizer
        }

        let recognizer = UIPanGestureRecognizer()
        recognizer.maximumNumberOfTouches = 1

        objc_setAssociatedObject(
            self,
            &AssociatedKeys.fullscreenPopGestureRecognizer,
            recognizer,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return recognizer
    }

    /// A view controller is able to control navigation bar's appearance by itself,
    /// rather than a global way, checking "fm_prefersNavigationBarHidden" property.
    /// Default to YES, disable it if you don't want so.
    /// 对应Objective-C的 fd_viewControllerBasedNavigationBarAppearanceEnabled
    var fm_viewControllerBasedNavigationBarAppearanceEnabled: Bool {
        get {
            if let number = objc_getAssociatedObject(self, &AssociatedKeys.viewControllerBasedNavigationBarAppearanceEnabled) as? NSNumber {
                return number.boolValue
            }
            // 默认值为true
            self.fm_viewControllerBasedNavigationBarAppearanceEnabled = true
            return true
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.viewControllerBasedNavigationBarAppearanceEnabled,
                NSNumber(value: newValue),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    // MARK: - Private Properties

    /// 对应Objective-C的 fd_popGestureRecognizerDelegate
    private var fm_popGestureRecognizerDelegate: FMFullscreenPopGestureRecognizerDelegate {
        // 延迟初始化
        if let delegate = objc_getAssociatedObject(self, &AssociatedKeys.popGestureRecognizerDelegate) as? FMFullscreenPopGestureRecognizerDelegate {
            return delegate
        }

        let delegate = FMFullscreenPopGestureRecognizerDelegate()
        delegate.navigationController = self

        objc_setAssociatedObject(
            self,
            &AssociatedKeys.popGestureRecognizerDelegate,
            delegate,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return delegate
    }

    // MARK: - Swizzled Methods

    /// 对应Objective-C的 - (void)fd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
    @objc internal dynamic func fm_pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 首次push时设置手势识别器
        if let gestureRecognizers = interactivePopGestureRecognizer?.view?.gestureRecognizers,
           !gestureRecognizers.contains(fm_fullscreenPopGestureRecognizer) {

            // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
            interactivePopGestureRecognizer?.view?.addGestureRecognizer(fm_fullscreenPopGestureRecognizer)

            // Forward the gesture events to the private handler of the onboard gesture recognizer.
            // 使用KVC获取系统手势识别器的内部target和action
            if let internalTargets = interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray,
               let firstTarget = internalTargets.firstObject as? NSObject,
               let internalTarget = firstTarget.value(forKey: "target") {
                let internalAction = NSSelectorFromString("handleNavigationTransition:")
                fm_fullscreenPopGestureRecognizer.addTarget(internalTarget, action: internalAction)
            }

            // 设置代理
            fm_fullscreenPopGestureRecognizer.delegate = fm_popGestureRecognizerDelegate
        }

        // IMPORTANT: 每次push都要确保系统手势被禁用，因为系统可能会重新启用它
        interactivePopGestureRecognizer?.isEnabled = false

        // Handle preferred navigation bar appearance.
        fm_setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: viewController)

        // Forward to primary implementation.
        // 注意：由于方法已交换，这里调用的实际是原始的pushViewController:animated:
        if !viewControllers.contains(viewController) {
            fm_pushViewController(viewController, animated: animated)
        }
    }

    // MARK: - Private Methods

    /// 对应Objective-C的 - (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
    private func fm_setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: UIViewController) {
        if !fm_viewControllerBasedNavigationBarAppearanceEnabled {
            return
        }

        weak var weakSelf = self
        let block: ViewControllerWillAppearInjectBlock = { viewController, animated in
            guard let strongSelf = weakSelf else { return }
            strongSelf.setNavigationBarHidden(viewController.fm_prefersNavigationBarHidden, animated: animated)
        }

        // Setup will appear inject block to appearing view controller.
        // Setup disappearing view controller as well, because not every view controller is added into
        // stack by pushing, maybe by "-setViewControllers:".
        appearingViewController.fm_willAppearInjectBlock = block

        if let disappearingViewController = viewControllers.last,
           disappearingViewController.fm_willAppearInjectBlock == nil {
            disappearingViewController.fm_willAppearInjectBlock = block
        }
    }
}
