import DependencyClients
import Features
import Models
import Testing

@Suite("HomeModelTests")
@MainActor
struct HomeModelTests {
    @Test("task updates number")
    func taskUpdatesNumber() async {
        let sut = HomeModel(
            apiClient: .mock(fetchNumber: { 13 })
        )

        await sut.task()

        #expect(sut.number == 13)
    }
}
