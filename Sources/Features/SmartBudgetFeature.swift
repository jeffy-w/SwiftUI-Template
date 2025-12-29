import Foundation
import Observation

@MainActor
@Observable
public final class SmartBudgetFeature {
    public enum Category: String, CaseIterable, Identifiable {
        case income = "Income"
        case expenses = "Expenses"
        case savings = "Savings"

        public var id: String { rawValue }
        public var icon: String {
            switch self {
            case .income: return "arrow.down.circle"
            case .expenses: return "arrow.up.circle"
            case .savings: return "leaf"
            }
        }
    }

    public var selectedCategory: Category = .income

    // Demo data for the chart
    public var chartData: [Double] = [0.3, 0.5, 0.2, 0.8, 0.4, 0.6, 0.9, 0.5, 0.3, 0.7]

    public init() {}

    public func selectCategory(_ category: Category) {
        selectedCategory = category
        // Simulate data change
        chartData = chartData.shuffled()
    }
}
