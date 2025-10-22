//
//  HiddenNavigationBarViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

/// 隐藏导航栏示例
class HiddenNavigationBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // 隐藏导航栏
        fm_prefersNavigationBarHidden = true

        let label = UILabel()
        label.text = """
        👻 导航栏已隐藏

        在这个页面中，导航栏被隐藏了，
        但全屏滑动返回仍然可用！

        代码实现：
        fm_prefersNavigationBarHidden = true

        从屏幕任意位置向右滑动即可返回。
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

        // 添加返回按钮
        let backButton = UIButton(type: .system)
        backButton.setTitle("← 返回", for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
