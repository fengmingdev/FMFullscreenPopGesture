//
//  LimitedTriggerAreaViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

/// 限制触发区域示例
class LimitedTriggerAreaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // 限制触发区域为左边50pt
        fm_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50

        let label = UILabel()
        label.text = """
        📏 触发区域受限

        在这个页面中，只有从屏幕左边缘50pt内开始
        滑动才能触发返回。

        代码实现：
        fm_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50

        试试从不同位置滑动看看效果！
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

        // 添加视觉指示器
        let indicator = UIView()
        indicator.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        view.sendSubviewToBack(indicator)

        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicator.topAnchor.constraint(equalTo: view.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
