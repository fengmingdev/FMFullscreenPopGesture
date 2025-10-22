//
//  BasicExampleViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

/// 基础示例 - 演示默认的全屏滑动返回效果
class BasicExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = """
        ✅ 全屏滑动返回已自动生效！

        你可以从屏幕任意位置向右滑动返回上一页，
        而不仅仅是从左边缘。

        试试从屏幕中间滑动返回吧！
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

        // 添加push按钮
        let button = UIButton(type: .system)
        button.setTitle("Push到下一页", for: .normal)
        button.addTarget(self, action: #selector(pushNextVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func pushNextVC() {
        let nextVC = BasicExampleViewController()
        nextVC.title = "第\(navigationController?.viewControllers.count ?? 0 + 1)页"
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
