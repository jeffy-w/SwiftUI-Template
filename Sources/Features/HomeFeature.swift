import DependencyClients
import FVendors
import Models
import Observation

@MainActor
@Observable
package final class HomeModel {
    package var number: Number = 0

    private let apiClient: APIClient

    package init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    package func task() async {
        do {
            number = try await apiClient.fetchNumber()
        } catch {
            // Intentionally ignore errors in the template.
        }
    }
}
