import SwiftUI

/// 加载状态视图
///
/// 显示加载动画和可选的提示文本
public struct LoadingView: View {
    /// 加载提示文本
    let message: String?

    /// 初始化加载视图
    /// - Parameter message: 加载提示文本（可选）
    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)

            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Loading without message") {
    LoadingView()
}

#Preview("Loading with message") {
    LoadingView(message: "加载中...")
}

#Preview("Loading in context") {
    NavigationStack {
        LoadingView(message: "正在获取数据...")
            .navigationTitle("加载示例")
    }
}
