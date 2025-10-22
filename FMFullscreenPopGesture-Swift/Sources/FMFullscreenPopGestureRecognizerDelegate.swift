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

// MARK: - FMFullscreenPopGestureRecognizerDelegate

/// 对应Objective-C的 _FDFullscreenPopGestureRecognizerDelegate
internal final class FMFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {

    // MARK: - Properties

    weak var navigationController: UINavigationController?

    // MARK: - UIGestureRecognizerDelegate

    /// 对应Objective-C的 - (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("🎯 [FMFullscreenPopGesture] gestureRecognizerShouldBegin called for: \(gestureRecognizer)")

        guard let navigationController = navigationController,
              let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            print("   ❌ No navigationController or not a pan gesture")
            return false
        }

        // CRITICAL: 只处理我们自己的自定义手势，忽略系统手势
        // 系统手势应该被禁用，但如果它的delegate被错误地设置为我们，我们必须拒绝它
        let customGesture = navigationController.fm_fullscreenPopGestureRecognizer
        let systemGesture = navigationController.interactivePopGestureRecognizer

        print("   🔍 Gesture comparison:")
        print("      Received gesture: \(gestureRecognizer)")
        print("      Custom gesture:   \(customGesture)")
        print("      System gesture:   \(String(describing: systemGesture))")
        print("      Are they same object? \(gestureRecognizer === customGesture)")

        if gestureRecognizer !== customGesture {
            print("   ❌ This is NOT our custom gesture, it's the system gesture! Rejecting.")
            return false
        }

        print("   ✅ This is our custom gesture, proceeding with checks...")

        // Ignore when no view controller is pushed into the navigation stack.
        if navigationController.viewControllers.count <= 1 {
            print("   ❌ Stack has <= 1 VC, rejecting")
            return false
        }
        print("   ✅ Stack check passed: \(navigationController.viewControllers.count) VCs")

        // Ignore when the active view controller doesn't allow interactive pop.
        guard let topViewController = navigationController.viewControllers.last else {
            print("   ❌ No top VC, rejecting")
            return false
        }
        print("   ✅ Top VC: \(type(of: topViewController))")

        print("   🔍 Checking fm_interactivePopDisabled: \(topViewController.fm_interactivePopDisabled)")
        if topViewController.fm_interactivePopDisabled {
            print("   ❌ fm_interactivePopDisabled = true, rejecting gesture")
            return false
        }
        print("   ✅ fm_interactivePopDisabled = false, continuing...")

        // Ignore when the beginning location is beyond max allowed initial distance to left edge.
        let beginningLocation = panGestureRecognizer.location(in: panGestureRecognizer.view)
        let maxAllowedInitialDistance = topViewController.fm_interactivePopMaxAllowedInitialDistanceToLeftEdge
        print("   🔍 Location check: beginningLocation.x=\(beginningLocation.x), maxAllowed=\(maxAllowedInitialDistance)")
        if maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance {
            print("   ❌ Location exceeds max allowed, rejecting")
            return false
        }
        print("   ✅ Location check passed")

        // Ignore pan gesture when the navigation controller is currently in transition.
        // 使用KVC访问私有属性 _isTransitioning
        if let isTransitioning = navigationController.value(forKey: "_isTransitioning") as? Bool,
           isTransitioning {
            print("   ❌ Navigation is transitioning, rejecting")
            return false
        }
        print("   ✅ Transition check passed")

        // Prevent calling the handler when the gesture begins in an opposite direction.
        let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        let multiplier: CGFloat = isLeftToRight ? 1 : -1
        print("   🔍 Direction check: translation.x=\(translation.x), multiplier=\(multiplier), result=\(translation.x * multiplier)")

        if (translation.x * multiplier) <= 0 {
            print("   ❌ Wrong direction, rejecting")
            return false
        }
        print("   ✅ Direction check passed")

        // Call custom block if exists
        if let shouldBeginBlock = topViewController.fm_shouldBeginBlock {
            let result = shouldBeginBlock()
            print("   🔍 Custom block returned: \(result)")
            return result
        }

        print("   ✅ ALL CHECKS PASSED - Gesture will begin!")
        return true
    }
}
