# 更新日志

所有重要的变更都会记录在此文件中。

本项目遵循 [语义化版本控制](https://semver.org/lang/zh-CN/)。

## [2.0.0] - 2024-01-XX

### 新增
- ✨ **Swift 重写**：完全使用 Swift 重写整个项目
- ✨ **Swift Package Manager 支持**：原生支持 SPM
- ✨ **iOS 13.0+ 支持**：最低支持 iOS 13.0
- ✨ **类型安全**：利用 Swift 强类型系统，提供更好的编译时检查
- ✨ **现代化 API**：使用 Swift 闭包、Optional 等现代语言特性
- ✨ **完整示例项目**：提供 5 个不同场景的示例视图控制器
- ✨ **单元测试**：添加完整的单元测试覆盖

### 变更
- 🔄 **API 前缀变更**：所有 API 前缀从 `fd_` 改为 `fm_`
- 🔄 **初始化方式**：从 Objective-C 的 `+load` 改为手动调用 `FMFullscreenPopGesture.setup()`
- 🔄 **闭包语法**：从 Block 改为 Swift Closure

### 迁移指南
详见 [README.md](README.md#从-objective-c-版本迁移) 中的迁移指南。

---

## [1.1.0] - 2023-04-21 (Objective-C版本)

### 新增
- ✨ 新增 `shouldBeginBlock` 属性，支持灵活控制返回手势

### 移除
- ❌ 删除 `fd_popDisabledStatus()` 监听方法（被 `shouldBeginBlock` 替代）

### 优化
- ⚡️ 更灵活的滑动返回外部控制机制

---

## [1.0.0] - 2023-04-06 (Objective-C版本)

### 新增
- ✨ 全屏滑动返回手势支持
- ✨ 按视图控制器级别的手势控制
- ✨ 限制触发区域支持
- ✨ 导航栏自动管理
- ✨ RTL 布局支持
- ✨ CocoaPods 支持

---

## 图例

- ✨ 新增功能
- 🔄 变更
- 🐛 修复
- ⚡️ 性能优化
- 📝 文档更新
- ❌ 移除
- 🔒 安全修复
