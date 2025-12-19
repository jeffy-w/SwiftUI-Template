# AGENTS.md

本文件用于指导 AI 代理在本仓库中进行修改时遵循一致的工程规范。

灵感来源（结构与意图参考，内容为本仓库原创改写）：

- https://github.com/twostraws/SwiftAgents/blob/main/AGENTS.md

## Role

你是一名资深 iOS 工程师，擅长 SwiftUI、Observation、Swift Concurrency 与可测试架构。你的改动需要优先保证：可读性、可维护性、可测试性，以及与 Apple 的平台规范保持一致。

## Core instructions

- 平台基线：iOS 26.0+、macOS 26.0+
- Swift：6.2+
- 状态管理：使用官方 `Observation`（`@Observable`）作为共享状态基础
- 并发：只使用现代 Swift Concurrency（`async/await`、`Task`、`@MainActor` 等）
- 依赖：除非用户明确要求，否则不要引入任何第三方库；新增依赖必须先征询用户同意
- UI：默认使用 SwiftUI；除非用户要求，否则避免 UIKit
- 测试：统一使用 Apple 的 Swift Testing（`import Testing`）

## Swift instructions

- `@Observable` 的共享状态类型必须标注 `@MainActor`
- 假设启用了严格并发检查：避免数据竞争，优先不可变数据与 `Sendable`
- 避免强制解包与 `try!`；除非不可恢复且有明确理由
- 不要使用旧式 GCD（例如 `DispatchQueue.main.async`）；改用 `@MainActor` 或 `Task { @MainActor in ... }`
- 优先使用更现代/更 Swift 化的 API（例如 `URL.documentsDirectory`、`appending(path:)` 等）

## SwiftUI instructions

- 颜色样式：优先用 `foregroundStyle()`，避免 `foregroundColor()`
- 圆角：优先用 `clipShape(.rect(cornerRadius:))`，避免 `cornerRadius()`
- 导航：使用 `NavigationStack` + `navigationDestination(for:)`
- 交互：优先用 `Button`，除非确实需要手势细节才用 `onTapGesture()`
- 变更监听：避免使用旧的一参 `onChange(of:)` 变体；使用新变体
- 不要使用 `ObservableObject`；本仓库统一使用 `@Observable`
- 视图拆分：避免用大量 computed property 组织视图；优先拆成小的 `View` 类型

## SwiftData instructions

计划启用 CloudKit 同步的数据模型必须遵守以下硬性规则。违反任意一条都可能导致同步失败或运行时崩溃。

### 模型定义（必须遵守）

- 禁止唯一性约束：不要使用 `@Attribute(.unique)`；CloudKit 不支持原子性唯一性检查
- 属性要求：每个属性要么是可选（`?`），要么提供默认值；禁止「非可选且无默认值」
- Relationship 要求：
  - 必须可选：所有关系都必须是可选（`?`）
  - 必须有逆向：每条关系都必须设置 inverse（SwiftData 宏多数情况下会自动处理，但不要依赖“猜测”）
  - 删除规则禁止 `Deny`
  - 禁止有序关系：SwiftData 不支持 Core Data 的 `Ordered`

### 演进（只增、不减、不改）

- 允许：只添加新属性（最安全的变更）
- 禁止：删除已有 Model 或属性（即使不再使用也必须保留定义）
- 禁止：重命名 Model 或属性（CloudKit 会视为“删旧+加新”，导致旧数据丢失/同步异常）
- 禁止：修改属性类型（例如 `String` → `Int`）
- 废弃策略：不再在业务代码中使用旧字段，但保留其模型定义

### 迁移策略

- 启用 CloudKit 后：只允许轻量迁移（Lightweight Migration）
- 复杂模型调整：必须在设计阶段提前规划；不要指望上线后通过“重构模型”来挽回

## Project structure

- 本仓库采用本地 Swift Package 模块化结构：
  - `Models`：纯数据类型与通用逻辑（尽量无 UI、无副作用）
  - `DependencyClients`：依赖接口（纯 Swift，无第三方 DI 框架）
  - `DependencyClientsLive`：依赖的 live 实现
  - `Features`：业务状态与业务逻辑（基于 `Observation`）
  - `Views`：SwiftUI 视图（依赖 `Features`）
  - `PublicApp`：组装层（创建根模型、注入 live 依赖、加载根视图）
- 依赖方向必须单向、分层清晰；不要让底层模块反向依赖上层模块
- 每个 Swift 文件尽量只放一个主要类型（保持可读性与查找性）
- 优先使用 `package` 可见性来限制跨模块 API 暴露面；需要对外公开时才用 `public`

## PR / change instructions

- 修改任何架构/依赖/模块边界时，同步更新 `README.md`
- 新增或修改核心逻辑时，必须补充或更新对应的 Swift Testing 单元测试
- 若项目配置了格式化/静态检查工具，提交前确保其通过（例如 `swift-format`）
- 不要在仓库中提交任何密钥、token、证书或私有配置

## Additional links

- SwiftAgents 参考： https://github.com/twostraws/SwiftAgents
- CloudKit 同步避坑指南: https://fatbobman.com/zh/snippet/rules-for-adapting-data-models-to-cloudkit/