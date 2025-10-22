//
//  DisabledGestureViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

/// 禁用返回手势示例
class DisabledGestureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // 禁用滑动返回
        fm_interactivePopDisabled = true
        print("✅ [DisabledGestureViewController] Set fm_interactivePopDisabled = true")
        print("✅ [DisabledGestureViewController] Verify: fm_interactivePopDisabled = \(fm_interactivePopDisabled)")

        // 额外检查: 验证系统手势是否被禁用
        if let navController = navigationController {
            print("🔍 [DisabledGestureViewController] System gesture enabled: \(navController.interactivePopGestureRecognizer?.isEnabled ?? false)")
            print("🔍 [DisabledGestureViewController] Custom gesture: \(navController.fm_fullscreenPopGestureRecognizer)")
        }

        let label = UILabel()
        label.text = """
        🚫 滑动返回已禁用

        在这个页面中，全屏滑动返回手势被禁用了。

        代码实现：
        fm_interactivePopDisabled = true

        请点击导航栏返回按钮返回。
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
