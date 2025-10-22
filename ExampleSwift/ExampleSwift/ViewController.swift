//
//  ViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

class ViewController: UIViewController {

    // MARK: - Properties

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let examples = [
        ("基础示例", "所有ViewController默认支持全屏滑动返回"),
        ("禁用返回手势", "演示如何禁用滑动返回"),
        ("限制触发区域", "只允许在屏幕左侧50pt内触发"),
        ("自定义返回逻辑", "通过闭包控制是否允许返回"),
        ("隐藏导航栏", "导航栏隐藏时仍支持滑动返回"),
        ("导航栏切换", "演示不同页面导航栏显示/隐藏切换")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let example = examples[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = example.0
        config.secondaryText = example.1
        config.secondaryTextProperties.numberOfLines = 0
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let example = examples[indexPath.row]
        var nextVC: UIViewController

        switch indexPath.row {
        case 0:
            nextVC = BasicExampleViewController()
        case 1:
            nextVC = DisabledGestureViewController()
        case 2:
            nextVC = LimitedTriggerAreaViewController()
        case 3:
            nextVC = CustomLogicViewController()
        case 4:
            nextVC = HiddenNavigationBarViewController()
        case 5:
            nextVC = NavigationBarToggleViewController()
        default:
            nextVC = BasicExampleViewController()
        }

        nextVC.title = example.0
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - Example View Controllers

/// 基础示例
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

/// 禁用返回手势
class DisabledGestureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // 禁用滑动返回
        fm_interactivePopDisabled = true

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

/// 限制触发区域
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

/// 自定义返回逻辑
class CustomLogicViewController: UIViewController {

    private var hasUnsavedChanges = false
    private let textView = UITextView()
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()

        // 设置自定义返回逻辑
        fm_shouldBeginBlock = { [weak self] in
            guard let self = self else { return true }

            if self.hasUnsavedChanges {
                self.showSaveAlert()
                return false  // 不允许返回
            }
            return true  // 允许返回
        }
    }

    private func setupUI() {
        // 标题标签
        let titleLabel = UILabel()
        titleLabel.text = "🔒 自定义返回逻辑"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // 说明标签
        let descLabel = UILabel()
        descLabel.text = "在文本框中输入内容后尝试返回，会弹出保存提示。"
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .secondaryLabel
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descLabel)

        // 文本框
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)

        // 状态标签
        statusLabel.text = "状态: 无未保存内容 ✅"
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            textView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 200),

            statusLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func showSaveAlert() {
        let alert = UIAlertController(
            title: "未保存的内容",
            message: "您有未保存的内容，确定要离开吗？",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "放弃", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

extension CustomLogicViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        hasUnsavedChanges = !textView.text.isEmpty
        statusLabel.text = hasUnsavedChanges ? "状态: 有未保存内容 ⚠️" : "状态: 无未保存内容 ✅"
        statusLabel.textColor = hasUnsavedChanges ? .systemOrange : .label
    }
}

/// 隐藏导航栏
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

/// 导航栏切换示例
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

