import Foundation
import SwiftData

/// 交易记录模型（用于记账）
@Model
public final class Transaction {
    /// 唯一标识符
    @Attribute(.unique) public var id: UUID

    /// 金额
    public var amount: Decimal

    /// 分类
    public var category: String

    /// 备注
    public var note: String

    /// 交易日期
    public var date: Date

    /// 是否为收入（true: 收入, false: 支出）
    public var isIncome: Bool

    /// 初始化交易记录
    /// - Parameters:
    ///   - id: 唯一标识符（默认自动生成）
    ///   - amount: 金额
    ///   - category: 分类
    ///   - note: 备注
    ///   - date: 交易日期（默认当前时间）
    ///   - isIncome: 是否为收入
    public init(
        id: UUID = UUID(),
        amount: Decimal,
        category: String,
        note: String = "",
        date: Date = Date(),
        isIncome: Bool = false
    ) {
        self.id = id
        self.amount = amount
        self.category = category
        self.note = note
        self.date = date
        self.isIncome = isIncome
    }
}
