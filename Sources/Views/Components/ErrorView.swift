import FVendors
import Models
import SwiftUI

/// 错误展示视图
public struct ErrorView: View {
    let error: AppError
    let retryAction: (@MainActor @Sendable () -> Void)?

    /// 初始化错误视图
    /// - Parameters:
    ///   - error: 要显示的错误
    ///   - retryAction: 可选的重试动作闭包
    public init(error: AppError, retryAction: (@MainActor @Sendable () -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }

    public var body: some View {
        ContentUnavailableView {
            Label("Error", systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.userMessage)
        } actions: {
            if let retryAction, error.isRecoverable {
                Button("Retry", action: retryAction)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview("Network Error - Recoverable") {
    ErrorView(
        error: .networkError(.noConnection),
        retryAction: { print("Retry tapped") }
    )
}

#Preview("Network Error - Not Recoverable") {
    ErrorView(
        error: .networkError(.decodingFailed),
        retryAction: { print("Retry tapped") }
    )
}

#Preview("Persistence Error") {
    ErrorView(
        error: .persistenceError(.saveFailed)
    )
}

#Preview("Validation Error") {
    ErrorView(
        error: .validationError("Invalid email address"),
        retryAction: { print("Retry tapped") }
    )
}
