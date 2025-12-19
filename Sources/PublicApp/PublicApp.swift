import DependencyClients
import DependencyClientsLive
import Features
import Models
import SwiftData
import SwiftUI
import Views

@main
public struct PublicApp: App {
    private let modelContainer: ModelContainer

    public init() {
        do {
            self.modelContainer = try ModelContainer(
                for: DiaryEntry.self,
                Transaction.self,
                PomodoroSession.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    public var body: some Scene {
        WindowGroup {
            AppView(
                model: AppModel(
                    apiClient: .live,
                    logger: .live)
            )
            .modelContainer(modelContainer)
        }
    }
}
