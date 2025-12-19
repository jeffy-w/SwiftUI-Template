import DependencyClients
import Features
import Models
import Observation
import SwiftData
import SwiftUI

package struct AppView: View {
    @Bindable var model: AppModel

    package init(model: AppModel) {
        self.model = model
    }

    package var body: some View {
        NavigationStack(path: $model.router.path) {
            HomeView(model: model.home, router: model.router)
                .navigationDestination(for: Route.self) { route in
                    RouterView(route: route, appModel: model)
                }
        }
        .task {
            await model.task()
        }
    }
}

#Preview {
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

    AppView(
        model: AppModel(
            apiClient: .mock(fetchNumber: { 42 })
        )
    )
    .modelContainer(container)
}
