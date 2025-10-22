//
//  CustomLogicViewController.swift
//  ExampleSwift
//
//  Created by fengming on 2025/10/22.
//

import UIKit
import FMFullscreenPopGesture

/// 自定义返回逻辑示例 - 演示未保存内容提示
class CustomLogicViewController: UIViewController {

    // MARK: - Properties

    private var hasUnsavedChanges = false
    private let textView = UITextView()
    private let statusLabel = UILabel()

    // MARK: - Lifecycle

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

    // MARK: - UI Setup

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

    // MARK: - Actions

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

// MARK: - UITextViewDelegate

extension CustomLogicViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        hasUnsavedChanges = !textView.text.isEmpty
        statusLabel.text = hasUnsavedChanges ? "状态: 有未保存内容 ⚠️" : "状态: 无未保存内容 ✅"
        statusLabel.textColor = hasUnsavedChanges ? .systemOrange : .label
    }
}
