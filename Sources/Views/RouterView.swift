import DependencyClients
import Features
import Models
import SwiftData
import SwiftUI

/// 路由视图工厂
///
/// 根据 Route 枚举创建对应的视图
struct RouterView: View {
    let route: Route
    let appModel: AppModel

    var body: some View {
        switch route {
        case .home:
            Text("Home Page")
                .navigationTitle(route.title)

        // MARK: - 演示/测试路由

        case .temp:
            TempView(model: appModel.temp, router: appModel.router)

        // MARK: - 日记路由

        case .diaryList:
            Text("Diary List")
                .navigationTitle(route.title)

        case .diaryDetail(let id):
            Text("Diary Detail: \(id.uuidString)")
                .navigationTitle(route.title)

        case .diaryEdit(let id):
            if let id = id {
                Text("Edit Diary: \(id.uuidString)")
                    .navigationTitle(route.title)
            } else {
                Text("New Diary")
                    .navigationTitle(route.title)
            }

        // MARK: - 记账路由

        case .transactionList:
            Text("Transaction List")
                .navigationTitle(route.title)

        case .transactionDetail(let id):
            Text("Transaction Detail: \(id.uuidString)")
                .navigationTitle(route.title)

        case .transactionEdit(let id):
            if let id = id {
                Text("Edit Transaction: \(id.uuidString)")
                    .navigationTitle(route.title)
            } else {
                Text("New Transaction")
                    .navigationTitle(route.title)
            }

        // MARK: - 番茄钟路由

        case .pomodoroTimer:
            Text("Pomodoro Timer")
                .navigationTitle(route.title)

        case .pomodoroHistory:
            Text("Pomodoro History")
                .navigationTitle(route.title)

        case .pomodoroSessionDetail(let id):
            Text("Session Detail: \(id.uuidString)")
                .navigationTitle(route.title)
        }
    }
}

#Preview("Temp View") {
    NavigationStack {
        let container: ModelContainer = {
            do {
                let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
                return try ModelContainer(
                    for: DiaryEntry.self,
                    Transaction.self,
                    PomodoroSession.self,
                    configurations: configuration
                )
            } catch {
                fatalError("Failed to create in-memory container: \(error)")
            }
        }()

        RouterView(
            route: .temp,
            appModel: AppModel(apiClient: .mock(fetchNumber: { 42 }))
        )
        .modelContainer(container)
    }
}

#Preview("Diary List") {
    NavigationStack {
        let container: ModelContainer = {
            do {
                let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
                return try ModelContainer(
                    for: DiaryEntry.self,
                    Transaction.self,
                    PomodoroSession.self,
                    configurations: configuration
                )
            } catch {
                fatalError("Failed to create in-memory container: \(error)")
            }
        }()

        RouterView(
            route: .diaryList,
            appModel: AppModel(apiClient: .mock(fetchNumber: { 42 }))
        )
        .modelContainer(container)
    }
}

#Preview("Diary Detail") {
    NavigationStack {
        let container: ModelContainer = {
            do {
                let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
                return try ModelContainer(
                    for: DiaryEntry.self,
                    Transaction.self,
                    PomodoroSession.self,
                    configurations: configuration
                )
            } catch {
                fatalError("Failed to create in-memory container: \(error)")
            }
        }()

        RouterView(
            route: .diaryDetail(id: UUID()),
            appModel: AppModel(apiClient: .mock(fetchNumber: { 42 }))
        )
        .modelContainer(container)
    }
}

#Preview("New Diary") {
    NavigationStack {
        let container: ModelContainer = {
            do {
                let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
                return try ModelContainer(
                    for: DiaryEntry.self,
                    Transaction.self,
                    PomodoroSession.self,
                    configurations: configuration
                )
            } catch {
                fatalError("Failed to create in-memory container: \(error)")
            }
        }()

        RouterView(
            route: .diaryEdit(id: nil),
            appModel: AppModel(apiClient: .mock(fetchNumber: { 42 }))
        )
        .modelContainer(container)
    }
}
