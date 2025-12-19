import Foundation
import SwiftData

/// 日记条目模型
@Model
public final class DiaryEntry {
    /// 唯一标识符
    @Attribute(.unique) public var id: UUID

    /// 标题
    public var title: String

    /// 内容
    public var content: String

    /// 创建时间
    public var createdAt: Date

    /// 最后更新时间
    public var updatedAt: Date

    /// 心情/情绪标记（可选）
    public var mood: String?

    /// 标签列表
    public var tags: [String]

    /// 初始化日记条目
    /// - Parameters:
    ///   - id: 唯一标识符（默认自动生成）
    ///   - title: 标题
    ///   - content: 内容
    ///   - createdAt: 创建时间（默认当前时间）
    ///   - updatedAt: 更新时间（默认当前时间）
    ///   - mood: 心情标记
    ///   - tags: 标签列表
    public init(
        id: UUID = UUID(),
        title: String,
        content: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        mood: String? = nil,
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.mood = mood
        self.tags = tags
    }
}
