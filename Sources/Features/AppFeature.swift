import DependencyClients
import FVendors
import Models
import Observation

@MainActor
@Observable
package final class AppModel {
    package var home: HomeModel
    package var temp: TempModel
    package var router: RouterModel

    package init(
        apiClient: APIClient,
        logger: LoggerClient = .noop,
        router: RouterModel = RouterModel()
    ) {
        self.home = HomeModel(apiClient: apiClient)
        self.temp = TempModel(
            apiClient: apiClient,
            logger: logger
        )
        self.router = router
    }

    package func task() async {
        // Reserved for app-wide startup work.
    }
}
