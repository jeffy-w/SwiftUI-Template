import Foundation

/// 应用路由定义
///
/// 定义应用中所有可能的导航目标
public enum Route: Hashable, Sendable {
    /// 首页
    case home

    // MARK: - 演示/测试路由

    /// 功能演示页面
    case temp

    // MARK: - 日记应用路由

    /// 日记列表
    case diaryList

    /// 日记详情
    /// - Parameter id: 日记 ID
    case diaryDetail(id: UUID)

    /// 新建/编辑日记
    /// - Parameter id: 日记 ID（nil 表示新建）
    case diaryEdit(id: UUID?)

    // MARK: - 记账应用路由

    /// 交易记录列表
    case transactionList

    /// 交易详情
    /// - Parameter id: 交易 ID
    case transactionDetail(id: UUID)

    /// 新建/编辑交易
    /// - Parameter id: 交易 ID（nil 表示新建）
    case transactionEdit(id: UUID?)

    // MARK: - 番茄钟应用路由

    /// 番茄钟主页
    case pomodoroTimer

    /// 番茄钟历史记录
    case pomodoroHistory

    /// 番茄钟会话详情
    /// - Parameter id: 会话 ID
    case pomodoroSessionDetail(id: UUID)
}

// MARK: - 路由元数据

extension Route {
    /// 路由显示名称
    public var title: String {
        switch self {
        case .home:
            return "首页"

        // 演示/测试
        case .temp:
            return "功能演示"

        // 日记
        case .diaryList:
            return "日记"
        case .diaryDetail:
            return "日记详情"
        case .diaryEdit(let id):
            return id == nil ? "新建日记" : "编辑日记"

        // 记账
        case .transactionList:
            return "记账"
        case .transactionDetail:
            return "交易详情"
        case .transactionEdit(let id):
            return id == nil ? "新建交易" : "编辑交易"

        // 番茄钟
        case .pomodoroTimer:
            return "番茄钟"
        case .pomodoroHistory:
            return "历史记录"
        case .pomodoroSessionDetail:
            return "会话详情"
        }
    }
}
