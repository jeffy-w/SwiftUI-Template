import Foundation
import SwiftData

/// 番茄钟会话模型
@Model
public final class PomodoroSession {
    /// 唯一标识符
    @Attribute(.unique) public var id: UUID

    /// 开始时间
    public var startTime: Date

    /// 结束时间（可选，会话进行中时为 nil）
    public var endTime: Date?

    /// 预设时长（分钟）
    public var duration: Int

    /// 任务名称
    public var taskName: String

    /// 是否已完成
    public var isCompleted: Bool

    /// 初始化番茄钟会话
    /// - Parameters:
    ///   - id: 唯一标识符（默认自动生成）
    ///   - startTime: 开始时间（默认当前时间）
    ///   - endTime: 结束时间
    ///   - duration: 预设时长（默认 25 分钟）
    ///   - taskName: 任务名称
    ///   - isCompleted: 是否已完成
    public init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        duration: Int = 25,
        taskName: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.taskName = taskName
        self.isCompleted = isCompleted
    }
}
