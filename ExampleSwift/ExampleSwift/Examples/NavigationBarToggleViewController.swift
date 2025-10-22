//
//  NavigationBarToggleViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

/// 导航栏切换示例 - 演示导航栏显示/隐藏的平滑切换
class NavigationBarToggleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = """
        🔄 导航栏显示

        这个页面显示导航栏。

        点击下面的按钮进入隐藏导航栏的页面，
        可以看到导航栏平滑切换的效果。
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let button = UIButton(type: .system)
        button.setTitle("进入隐藏导航栏的页面", for: .normal)
        button.addTarget(self, action: #selector(pushHiddenVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func pushHiddenVC() {
        let hiddenVC = HiddenNavigationBarViewController()
        hiddenVC.title = "隐藏导航栏"
        navigationController?.pushViewController(hiddenVC, animated: true)
    }
}
