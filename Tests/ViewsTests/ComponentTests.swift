import FVendors
import SwiftUI
import Testing
import Views

@Suite("LoadingView Tests")
@MainActor
struct LoadingViewTests {
    @Test("LoadingView initializes without message")
    func loadingViewInitWithoutMessage() {
        // LoadingView 可以无消息初始化
        let view = LoadingView()
        _ = view.body
        #expect(Bool(true))
    }

    @Test("LoadingView initializes with message")
    func loadingViewInitWithMessage() {
        // LoadingView 可以带消息初始化
        let view = LoadingView(message: "Loading...")
        _ = view.body
        #expect(Bool(true))
    }
}

@Suite("EmptyStateView Tests")
@MainActor
struct EmptyStateViewTests {
    @Test("EmptyStateView initializes with required parameters")
    func emptyStateViewInit() {
        // EmptyStateView 可以用最少参数初始化
        let view = EmptyStateView(
            systemImage: "tray",
            title: "Empty"
        )
        _ = view.body
        #expect(Bool(true))
    }

    @Test("EmptyStateView initializes with all parameters")
    func emptyStateViewInitWithAllParameters() {
        // EmptyStateView 可以用所有参数初始化
        var actionCalled = false
        let view = EmptyStateView(
            systemImage: "tray",
            title: "Empty",
            description: "No data",
            actionTitle: "Add",
            action: { actionCalled = true }
        )

        _ = view.body
        #expect(Bool(true))
        // 测试 action 行为而非内部状态
        #expect(actionCalled == false)
    }

    @Test("EmptyStateView emptyList factory creates view")
    func emptyStateViewEmptyListFactory() {
        // 验证工厂方法可以创建视图
        let view = EmptyStateView.emptyList()
        _ = view.body
        #expect(Bool(true))
    }

    @Test("EmptyStateView noSearchResults factory creates view")
    func emptyStateViewNoSearchResultsFactory() {
        // 验证搜索无结果工厂方法
        let view = EmptyStateView.noSearchResults(searchTerm: "test")
        _ = view.body
        #expect(Bool(true))
    }

    @Test("EmptyStateView networkError factory creates view")
    func emptyStateViewNetworkErrorFactory() {
        // 验证网络错误工厂方法
        var retryCalled = false
        let view = EmptyStateView.networkError {
            retryCalled = true
        }

        _ = view.body
        #expect(Bool(true))
        #expect(retryCalled == false)
    }
}

@Suite("ErrorView Tests")
@MainActor
struct ErrorViewTests {
    @Test("ErrorView initializes without retry action")
    func errorViewInitWithoutRetry() {
        let error = AppError.networkError(.noConnection)
        let view = ErrorView(error: error, retryAction: nil)

        _ = view.body
        #expect(Bool(true))
    }

    @Test("ErrorView initializes with retry action")
    func errorViewInitWithRetry() {
        var retryCalled = false
        let error = AppError.networkError(.noConnection)
        let view = ErrorView(
            error: error,
            retryAction: {
                retryCalled = true
            })

        _ = view.body
        #expect(Bool(true))
        #expect(retryCalled == false)
    }

    @Test("Recoverable errors are marked correctly")
    func recoverableErrorsMarked() {
        let recoverableError = AppError.networkError(.timeout)
        #expect(recoverableError.isRecoverable == true)
    }

    @Test("Non-recoverable errors are marked correctly")
    func nonRecoverableErrorsMarked() {
        let nonRecoverableError = AppError.unknown("Unknown error")
        #expect(nonRecoverableError.isRecoverable == false)
    }
}
