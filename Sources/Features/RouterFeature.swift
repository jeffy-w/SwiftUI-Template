import Models
import Observation
import SwiftUI

/// 路由管理器
///
/// 使用 SwiftUI 的 NavigationStack 管理应用导航
@MainActor
@Observable
public final class RouterModel {
    /// 导航路径
    public var path: NavigationPath

    /// 初始化路由管理器
    /// - Parameter path: 初始导航路径
    public init(path: NavigationPath = NavigationPath()) {
        self.path = path
    }

    // MARK: - 导航操作

    /// 导航到指定路由
    /// - Parameter route: 目标路由
    public func navigate(to route: Route) {
        path.append(route)
    }

    /// 返回上一级
    public func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// 返回根页面
    public func popToRoot() {
        path = NavigationPath()
    }

    /// 替换当前路由
    /// - Parameter route: 新路由
    public func replace(with route: Route) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }

    // MARK: - 快捷导航方法

    /// 导航到日记列表
    public func navigateToDiaryList() {
        navigate(to: .diaryList)
    }

    /// 导航到新建日记
    public func navigateToNewDiary() {
        navigate(to: .diaryEdit(id: nil))
    }

    /// 导航到日记详情
    /// - Parameter id: 日记 ID
    public func navigateToDiaryDetail(id: UUID) {
        navigate(to: .diaryDetail(id: id))
    }

    /// 导航到交易列表
    public func navigateToTransactionList() {
        navigate(to: .transactionList)
    }

    /// 导航到新建交易
    public func navigateToNewTransaction() {
        navigate(to: .transactionEdit(id: nil))
    }

    /// 导航到交易详情
    /// - Parameter id: 交易 ID
    public func navigateToTransactionDetail(id: UUID) {
        navigate(to: .transactionDetail(id: id))
    }

    /// 导航到番茄钟
    public func navigateToPomodoroTimer() {
        navigate(to: .pomodoroTimer)
    }

    /// 导航到番茄钟历史
    public func navigateToPomodoroHistory() {
        navigate(to: .pomodoroHistory)
    }
}
