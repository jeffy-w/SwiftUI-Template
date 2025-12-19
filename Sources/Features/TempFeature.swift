import DependencyClients
import FVendors
import Foundation
import Models
import Observation

/// 临时演示功能的 Model
///
/// 用于测试和演示模板的所有基础功能
@MainActor
@Observable
package final class TempModel {
    // MARK: - 状态

    /// 当前视图状态
    package enum ViewState {
        case idle
        case loading
        case empty
        case error(AppError)
        case loaded(data: String)
    }

    package var viewState: ViewState = .idle
    package var fetchedNumber: Number = 0

    // MARK: - 依赖

    private let apiClient: APIClient
    private let logger: LoggerClient

    // MARK: - 初始化

    package init(
        apiClient: APIClient,
        logger: LoggerClient = .noop
    ) {
        self.apiClient = apiClient
        self.logger = logger
    }

    // MARK: - 网络请求演示

    /// 演示成功的网络请求
    package func testSuccessfulNetworkRequest() async {
        logger.info("开始测试网络请求")
        viewState = .loading

        do {
            try await Task.sleep(for: .seconds(1))  // 模拟网络延迟
            let number = try await apiClient.fetchNumber()
            fetchedNumber = number
            viewState = .loaded(data: "获取到数字: \(number.rawValue)")
            logger.info("网络请求成功: \(number.rawValue)")
        } catch {
            let appError = AppError.from(error)
            viewState = .error(appError)
            logger.error("网络请求失败: \(appError.userMessage)")
        }
    }

    /// 演示网络错误
    package func testNetworkError() async {
        logger.warning("模拟网络错误")
        viewState = .loading

        try? await Task.sleep(for: .seconds(1))
        viewState = .error(.networkError(.noConnection))
    }

    /// 演示空状态
    package func testEmptyState() {
        logger.info("显示空状态")
        viewState = .empty
    }

    // MARK: - 日志演示

    /// 演示所有日志级别
    package func testAllLogLevels() {
        logger.debug("这是一条 DEBUG 日志")
        logger.info("这是一条 INFO 日志")
        logger.warning("这是一条 WARNING 日志")
        logger.error("这是一条 ERROR 日志")
        logger.critical("这是一条 CRITICAL 日志")

        viewState = .loaded(data: "已输出所有级别的日志（查看 Console.app）")
    }

    // MARK: - 错误处理

    package func handleError(_ error: any Error) {
        let appError = AppError.from(error)
        viewState = .error(appError)
        logger.error("发生错误: \(appError.userMessage)")
    }

    /// 重置状态
    package func reset() {
        logger.info("重置状态")
        viewState = .idle
        fetchedNumber = 0
    }
}
