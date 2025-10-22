//
//  ViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

/// 主界面 - 展示所有示例场景
class ViewController: UIViewController {

    // MARK: - Properties

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let examples: [(title: String, description: String, vcType: UIViewController.Type)] = [
        ("基础示例", "所有ViewController默认支持全屏滑动返回", BasicExampleViewController.self),
        ("禁用返回手势", "演示如何禁用滑动返回", DisabledGestureViewController.self),
        ("限制触发区域", "只允许在屏幕左侧50pt内触发", LimitedTriggerAreaViewController.self),
        ("自定义返回逻辑", "通过闭包控制是否允许返回", CustomLogicViewController.self),
        ("隐藏导航栏", "导航栏隐藏时仍支持滑动返回", HiddenNavigationBarViewController.self),
        ("导航栏切换", "演示不同页面导航栏显示/隐藏切换", NavigationBarToggleViewController.self)
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FMFullscreenPopGesture"
        view.backgroundColor = .systemBackground

        setupTableView()
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建支持副标题的 cell（iOS 13 兼容）
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let example = examples[indexPath.row]

        cell.textLabel?.text = example.title
        cell.detailTextLabel?.text = example.description
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let example = examples[indexPath.row]
        let nextVC = example.vcType.init()
        nextVC.title = example.title

        navigationController?.pushViewController(nextVC, animated: true)
    }
}
