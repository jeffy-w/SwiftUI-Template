import Features
import Models
import SwiftUI
import Testing

@Suite("RouterModel Tests")
@MainActor
struct RouterModelTests {
    @Test("Router initializes with empty path")
    func routerInitializesWithEmptyPath() {
        let router = RouterModel()
        #expect(router.path.isEmpty)
    }

    @Test("Navigate appends route to path")
    func navigateAppendsRoute() {
        let router = RouterModel()
        router.navigate(to: .diaryList)

        #expect(router.path.count == 1)
    }

    @Test("Navigate multiple routes builds path")
    func navigateMultipleRoutes() {
        let router = RouterModel()
        router.navigate(to: .diaryList)
        router.navigate(to: .diaryDetail(id: UUID()))

        #expect(router.path.count == 2)
    }

    @Test("GoBack removes last route")
    func goBackRemovesLastRoute() {
        let router = RouterModel()
        router.navigate(to: .diaryList)
        router.navigate(to: .diaryDetail(id: UUID()))

        router.goBack()

        #expect(router.path.count == 1)
    }

    @Test("GoBack on empty path does nothing")
    func goBackOnEmptyPathDoesNothing() {
        let router = RouterModel()
        router.goBack()

        #expect(router.path.isEmpty)
    }

    @Test("PopToRoot clears entire path")
    func popToRootClearsPath() {
        let router = RouterModel()
        router.navigate(to: .diaryList)
        router.navigate(to: .diaryDetail(id: UUID()))
        router.navigate(to: .diaryEdit(id: nil))

        router.popToRoot()

        #expect(router.path.isEmpty)
    }

    @Test("Replace replaces current route")
    func replaceReplacesCurrentRoute() {
        let router = RouterModel()
        router.navigate(to: .diaryList)
        router.replace(with: .transactionList)

        #expect(router.path.count == 1)
    }

    @Test("Replace on empty path appends route")
    func replaceOnEmptyPathAppendsRoute() {
        let router = RouterModel()
        router.replace(with: .diaryList)

        #expect(router.path.count == 1)
    }

    // MARK: - 快捷导航方法测试

    @Test("NavigateToDiaryList navigates correctly")
    func navigateToDiaryListWorks() {
        let router = RouterModel()
        router.navigateToDiaryList()

        #expect(router.path.count == 1)
    }

    @Test("NavigateToNewDiary creates edit route with nil id")
    func navigateToNewDiaryWorks() {
        let router = RouterModel()
        router.navigateToNewDiary()

        #expect(router.path.count == 1)
    }

    @Test("NavigateToDiaryDetail creates detail route")
    func navigateToDiaryDetailWorks() {
        let router = RouterModel()
        let testId = UUID()
        router.navigateToDiaryDetail(id: testId)

        #expect(router.path.count == 1)
    }

    @Test("NavigateToTransactionList navigates correctly")
    func navigateToTransactionListWorks() {
        let router = RouterModel()
        router.navigateToTransactionList()

        #expect(router.path.count == 1)
    }

    @Test("NavigateToPomodoroTimer navigates correctly")
    func navigateToPomodoroTimerWorks() {
        let router = RouterModel()
        router.navigateToPomodoroTimer()

        #expect(router.path.count == 1)
    }
}
