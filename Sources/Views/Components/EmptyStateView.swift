import SwiftUI

/// 空状态视图
///
/// 显示空数据状态，包含图标、标题、描述和可选操作按钮
public struct EmptyStateView: View {
    /// 空状态图标
    let systemImage: String

    /// 空状态标题
    let title: String

    /// 空状态描述
    let description: String?

    /// 操作按钮标题
    let actionTitle: String?

    /// 操作按钮回调
    let action: (@MainActor @Sendable () -> Void)?

    /// 初始化空状态视图
    /// - Parameters:
    ///   - systemImage: SF Symbols 图标名称
    ///   - title: 标题文本
    ///   - description: 描述文本（可选）
    ///   - actionTitle: 操作按钮标题（可选）
    ///   - action: 操作按钮回调（可选）
    public init(
        systemImage: String,
        title: String,
        description: String? = nil,
        actionTitle: String? = nil,
        action: (@MainActor @Sendable () -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            if let description = description {
                Text(description)
            }
        } actions: {
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

// MARK: - 预设空状态

extension EmptyStateView {
    /// 空列表状态
    public static func emptyList(
        title: String = "暂无数据",
        description: String? = "列表为空，请添加新项目",
        actionTitle: String? = "添加",
        action: (@MainActor @Sendable () -> Void)? = nil
    ) -> EmptyStateView {
        EmptyStateView(
            systemImage: "tray",
            title: title,
            description: description,
            actionTitle: actionTitle,
            action: action
        )
    }

    /// 搜索无结果状态
    public static func noSearchResults(
        searchTerm: String? = nil
    ) -> EmptyStateView {
        let description: String
        if let term = searchTerm {
            description = "没有找到与\"\(term)\"相关的内容"
        } else {
            description = "没有找到相关内容"
        }

        return EmptyStateView(
            systemImage: "magnifyingglass",
            title: "无搜索结果",
            description: description
        )
    }

    /// 网络错误状态
    public static func networkError(
        retryAction: @escaping @MainActor @Sendable () -> Void
    ) -> EmptyStateView {
        EmptyStateView(
            systemImage: "wifi.slash",
            title: "网络连接失败",
            description: "请检查网络连接后重试",
            actionTitle: "重试",
            action: retryAction
        )
    }
}

#Preview("Empty List without action") {
    EmptyStateView(
        systemImage: "tray",
        title: "暂无数据",
        description: "列表为空"
    )
}

#Preview("Empty List with action") {
    EmptyStateView.emptyList {
        print("Add tapped")
    }
}

#Preview("No Search Results") {
    EmptyStateView.noSearchResults(searchTerm: "测试")
}

#Preview("Network Error") {
    EmptyStateView.networkError {
        print("Retry tapped")
    }
}

#Preview("In Navigation Stack") {
    NavigationStack {
        EmptyStateView.emptyList(
            actionTitle: "添加日记",
            action: { print("Add diary") }
        )
        .navigationTitle("日记列表")
    }
}
