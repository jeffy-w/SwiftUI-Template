import DependencyClients
import Features
import Models
import SwiftData
import SwiftUI

/// 临时演示视图
///
/// 用于测试和演示模板的所有基础功能
struct TempView: View {
    @Bindable var model: TempModel
    let router: RouterModel

    @Environment(\.modelContext) private var modelContext
    @Query private var diaryEntries: [DiaryEntry]

    init(model: TempModel, router: RouterModel) {
        self.model = model
        self.router = router
        self._diaryEntries = Query(
            sort: [SortDescriptor<DiaryEntry>(\.createdAt, order: .reverse)]
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 标题
                headerSection

                // 状态显示区域
                stateDisplaySection

                // 网络请求测试
                networkSection

                // 数据持久化测试
                persistenceSection

                // 路由导航测试
                routingSection

                // 日志测试
                loggingSection

                // 重置按钮
                resetSection
            }
            .padding()
        }
        .navigationTitle("功能演示")
    }

    // MARK: - 视图组件

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("🎯 SwiftUI 模板功能演示")
                .font(.title2)
                .fontWeight(.bold)

            Text("测试所有基础设施功能")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var stateDisplaySection: some View {
        GroupBox("当前状态") {
            switch model.viewState {
            case .idle:
                Text("就绪 - 点击下方按钮开始测试")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

            case .loading:
                LoadingView(message: "处理中...")

            case .empty:
                EmptyStateView.emptyList(
                    title: "暂无内容",
                    description: "这是一个空状态展示",
                    actionTitle: "重置",
                    action: { model.reset() }
                )

            case .error(let error):
                ErrorView(
                    error: error,
                    retryAction: {
                        Task { await model.testSuccessfulNetworkRequest() }
                    }
                )

            case .loaded(let data):
                VStack(alignment: .leading, spacing: 8) {
                    Label("成功", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.headline)

                    Text(data)
                        .foregroundStyle(.secondary)

                    if model.fetchedNumber.rawValue > 0 {
                        Text("获取的数字: \(model.fetchedNumber.rawValue)")
                            .font(.title)
                            .foregroundStyle(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(minHeight: 200)
    }

    private var networkSection: some View {
        GroupBox {
            VStack(spacing: 12) {
                Text("网络请求测试")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    Button {
                        Task { await model.testSuccessfulNetworkRequest() }
                    } label: {
                        Label("成功请求", systemImage: "network")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        Task { await model.testNetworkError() }
                    } label: {
                        Label("模拟错误", systemImage: "wifi.slash")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
        }
    }

    private var persistenceSection: some View {
        GroupBox {
            VStack(spacing: 12) {
                Text("数据持久化测试")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    Button {
                        createSampleDiary()
                    } label: {
                        Label("创建日记", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)

                    Button {
                        clearAllDiaries()
                    } label: {
                        Label("清空", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }

                // 日记列表
                if diaryEntries.isEmpty {
                    Divider()
                    Text("暂无日记（由 @Query 自动读取）")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("已保存的日记 (\(diaryEntries.count))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        ForEach(diaryEntries) { entry in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.title)
                                        .font(.subheadline)
                                        .fontWeight(.medium)

                                    Text(entry.createdAt.formatted(.relative(presentation: .named)))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if let mood = entry.mood {
                                    Text(mood)
                                }
                            }
                            .padding(8)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
        }
    }

    private func createSampleDiary() {
        let entry = DiaryEntry(
            title: "测试日记 \(Date().formatted(.dateTime.hour().minute()))",
            content: "这是一条测试日记，用于演示 SwiftData。",
            mood: "😊"
        )

        modelContext.insert(entry)

        do {
            try modelContext.save()
            model.viewState = .loaded(data: "日记创建成功")
        } catch {
            model.handleError(error)
        }
    }

    private func clearAllDiaries() {
        guard !diaryEntries.isEmpty else {
            model.viewState = .loaded(data: "暂无可删除的日记")
            return
        }

        for entry in diaryEntries {
            modelContext.delete(entry)
        }

        do {
            try modelContext.save()
            model.viewState = .loaded(data: "已删除所有日记")
        } catch {
            model.handleError(error)
        }
    }

    private var routingSection: some View {
        GroupBox {
            VStack(spacing: 12) {
                Text("路由导航测试")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ], spacing: 12
                ) {
                    Button {
                        router.navigateToDiaryList()
                    } label: {
                        Label("日记列表", systemImage: "book")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        router.navigateToTransactionList()
                    } label: {
                        Label("记账列表", systemImage: "dollarsign.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        router.navigateToPomodoroTimer()
                    } label: {
                        Label("番茄钟", systemImage: "timer")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        router.navigate(to: .smartBudget)
                    } label: {
                        Label("智能预算", systemImage: "chart.pie")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        router.navigateToNewDiary()
                    } label: {
                        Label("新建日记", systemImage: "square.and.pencil")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                }

                Text("当前导航层级: \(router.path.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var loggingSection: some View {
        GroupBox {
            VStack(spacing: 12) {
                Text("日志系统测试")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    model.testAllLogLevels()
                } label: {
                    Label("测试所有日志级别", systemImage: "doc.text.magnifyingglass")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Text("日志输出到系统 Console（可用 Console.app 查看）")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var resetSection: some View {
        Button {
            model.reset()
        } label: {
            Label("重置所有状态", systemImage: "arrow.counterclockwise")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

#Preview {
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

        TempView(
            model: TempModel(
                apiClient: .mock(fetchNumber: { 42 })
            ),
            router: RouterModel()
        )
        .modelContainer(container)
    }
}
