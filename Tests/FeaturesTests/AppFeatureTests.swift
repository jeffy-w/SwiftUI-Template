import DependencyClients
import Features
import Testing

@Suite("AppModelTests")
@MainActor
struct AppModelTests {
    @Test("task runs")
    func taskRuns() async {
        let sut = AppModel(
            apiClient: .mock(fetchNumber: { 42 })
        )

        await sut.task()

        #expect(sut.home.number == 0)
    }
}
