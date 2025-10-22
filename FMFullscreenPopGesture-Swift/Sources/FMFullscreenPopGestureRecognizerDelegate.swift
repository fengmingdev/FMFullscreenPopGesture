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
        guard let navigationController = navigationController,
              let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }

        // Ignore when no view controller is pushed into the navigation stack.
        if navigationController.viewControllers.count <= 1 {
            return false
        }

        // Ignore when the active view controller doesn't allow interactive pop.
        guard let topViewController = navigationController.viewControllers.last else {
            return false
        }

        if topViewController.fm_interactivePopDisabled {
            return false
        }

        // Ignore when the beginning location is beyond max allowed initial distance to left edge.
        let beginningLocation = panGestureRecognizer.location(in: panGestureRecognizer.view)
        let maxAllowedInitialDistance = topViewController.fm_interactivePopMaxAllowedInitialDistanceToLeftEdge
        if maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance {
            return false
        }

        // Ignore pan gesture when the navigation controller is currently in transition.
        // 使用KVC访问私有属性 _isTransitioning
        if let isTransitioning = navigationController.value(forKey: "_isTransitioning") as? Bool,
           isTransitioning {
            return false
        }

        // Prevent calling the handler when the gesture begins in an opposite direction.
        let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        let multiplier: CGFloat = isLeftToRight ? 1 : -1

        if (translation.x * multiplier) <= 0 {
            return false
        }

        // Call custom block if exists
        if let shouldBeginBlock = topViewController.fm_shouldBeginBlock {
            return shouldBeginBlock()
        }

        return true
    }
}
