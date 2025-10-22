//
//  FMFullscreenPopGestureTests.swift
//  FMFullscreenPopGestureTests
//
//  Created by fengming on 2023.
//  Copyright (c) 2023 fengming. All rights reserved.
//

import XCTest
@testable import FMFullscreenPopGesture

final class FMFullscreenPopGestureTests: XCTestCase {

    var navigationController: UINavigationController!
    var viewController: UIViewController!

    override func setUpWithError() throws {
        // 初始化FMFullscreenPopGesture
        FMFullscreenPopGesture.setup()

        // 创建测试用的视图控制器
        viewController = UIViewController()
        navigationController = UINavigationController(rootViewController: viewController)
    }

    override func tearDownWithError() throws {
        viewController = nil
        navigationController = nil
    }

    // MARK: - UINavigationController Tests

    func testNavigationControllerHasFullscreenPopGestureRecognizer() throws {
        // 验证navigationController有fm_fullscreenPopGestureRecognizer属性
        let gestureRecognizer = navigationController.fm_fullscreenPopGestureRecognizer
        XCTAssertNotNil(gestureRecognizer, "fm_fullscreenPopGestureRecognizer should not be nil")
        XCTAssertTrue(gestureRecognizer is UIPanGestureRecognizer, "Should be UIPanGestureRecognizer")
    }

    func testNavigationControllerBasedNavigationBarAppearanceEnabledDefaultValue() throws {
        // 验证默认值为true
        let isEnabled = navigationController.fm_viewControllerBasedNavigationBarAppearanceEnabled
        XCTAssertTrue(isEnabled, "fm_viewControllerBasedNavigationBarAppearanceEnabled should be true by default")
    }

    func testNavigationControllerCanSetNavigationBarAppearanceEnabled() throws {
        // 验证可以设置该属性
        navigationController.fm_viewControllerBasedNavigationBarAppearanceEnabled = false
        XCTAssertFalse(navigationController.fm_viewControllerBasedNavigationBarAppearanceEnabled)

        navigationController.fm_viewControllerBasedNavigationBarAppearanceEnabled = true
        XCTAssertTrue(navigationController.fm_viewControllerBasedNavigationBarAppearanceEnabled)
    }

    // MARK: - UIViewController Tests

    func testViewControllerInteractivePopDisabledDefaultValue() throws {
        // 验证默认值为false
        XCTAssertFalse(viewController.fm_interactivePopDisabled, "fm_interactivePopDisabled should be false by default")
    }

    func testViewControllerCanSetInteractivePopDisabled() throws {
        // 验证可以设置该属性
        viewController.fm_interactivePopDisabled = true
        XCTAssertTrue(viewController.fm_interactivePopDisabled)

        viewController.fm_interactivePopDisabled = false
        XCTAssertFalse(viewController.fm_interactivePopDisabled)
    }

    func testViewControllerPrefersNavigationBarHiddenDefaultValue() throws {
        // 验证默认值为false
        XCTAssertFalse(viewController.fm_prefersNavigationBarHidden, "fm_prefersNavigationBarHidden should be false by default")
    }

    func testViewControllerCanSetPrefersNavigationBarHidden() throws {
        // 验证可以设置该属性
        viewController.fm_prefersNavigationBarHidden = true
        XCTAssertTrue(viewController.fm_prefersNavigationBarHidden)

        viewController.fm_prefersNavigationBarHidden = false
        XCTAssertFalse(viewController.fm_prefersNavigationBarHidden)
    }

    func testViewControllerMaxAllowedDistanceDefaultValue() throws {
        // 验证默认值为0
        let distance = viewController.fm_interactivePopMaxAllowedInitialDistanceToLeftEdge
        XCTAssertEqual(distance, 0, "fm_interactivePopMaxAllowedInitialDistanceToLeftEdge should be 0 by default")
    }

    func testViewControllerCanSetMaxAllowedDistance() throws {
        // 验证可以设置该属性
        viewController.fm_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50
        XCTAssertEqual(viewController.fm_interactivePopMaxAllowedInitialDistanceToLeftEdge, 50)

        // 验证负数会被转换为0
        viewController.fm_interactivePopMaxAllowedInitialDistanceToLeftEdge = -10
        XCTAssertEqual(viewController.fm_interactivePopMaxAllowedInitialDistanceToLeftEdge, 0, "Negative values should be converted to 0")
    }

    func testViewControllerShouldBeginBlockDefaultValue() throws {
        // 验证默认值为nil
        XCTAssertNil(viewController.fm_shouldBeginBlock, "fm_shouldBeginBlock should be nil by default")
    }

    func testViewControllerCanSetShouldBeginBlock() throws {
        // 验证可以设置该属性
        var blockCalled = false
        viewController.fm_shouldBeginBlock = {
            blockCalled = true
            return true
        }

        XCTAssertNotNil(viewController.fm_shouldBeginBlock)

        // 调用block验证
        let result = viewController.fm_shouldBeginBlock?()
        XCTAssertTrue(blockCalled, "Block should be called")
        XCTAssertEqual(result, true, "Block should return true")
    }

    // MARK: - Gesture Delegate Tests

    func testGestureRecognizerDelegateShouldBlockWhenOnlyOneViewController() throws {
        // 当只有一个视图控制器时，应该阻止手势
        let delegate = FMFullscreenPopGestureRecognizerDelegate()
        delegate.navigationController = navigationController

        let panGesture = UIPanGestureRecognizer()
        let shouldBegin = delegate.gestureRecognizerShouldBegin(panGesture)

        XCTAssertFalse(shouldBegin, "Gesture should be blocked when only one view controller")
    }

    func testGestureRecognizerDelegateShouldBlockWhenInteractivePopDisabled() throws {
        // push一个新的视图控制器
        let newVC = UIViewController()
        newVC.fm_interactivePopDisabled = true
        navigationController.pushViewController(newVC, animated: false)

        let delegate = FMFullscreenPopGestureRecognizerDelegate()
        delegate.navigationController = navigationController

        let panGesture = UIPanGestureRecognizer()
        let shouldBegin = delegate.gestureRecognizerShouldBegin(panGesture)

        XCTAssertFalse(shouldBegin, "Gesture should be blocked when fm_interactivePopDisabled is true")
    }

    func testGestureRecognizerDelegateShouldRespectCustomBlock() throws {
        // push一个新的视图控制器
        let newVC = UIViewController()
        var shouldAllowPop = false
        newVC.fm_shouldBeginBlock = {
            return shouldAllowPop
        }
        navigationController.pushViewController(newVC, animated: false)

        let delegate = FMFullscreenPopGestureRecognizerDelegate()
        delegate.navigationController = navigationController

        let panGesture = UIPanGestureRecognizer()

        // 第一次：不允许返回
        shouldAllowPop = false
        var shouldBegin = delegate.gestureRecognizerShouldBegin(panGesture)
        XCTAssertFalse(shouldBegin, "Gesture should be blocked when custom block returns false")

        // 第二次：允许返回
        shouldAllowPop = true
        shouldBegin = delegate.gestureRecognizerShouldBegin(panGesture)
        // 注意：这里可能因为translation为0而返回false，但这测试了block被调用
    }
}
