import Features
import Models
import Observation
import SwiftUI

struct HomeView: View {
    @Bindable var model: HomeModel
    let router: RouterModel

    init(model: HomeModel, router: RouterModel) {
        self.model = model
        self.router = router
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Home", bundle: Bundle.module)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("SwiftUI 模板项目")
                .font(.title3)
                .foregroundStyle(.secondary)

            Spacer()

            // 导航到功能演示页面的按钮
            Button {
                router.navigate(to: .temp)
            } label: {
                Label("查看功能演示", systemImage: "play.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)

            Text("点击按钮体验所有基础功能")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .task {
            await model.task()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            model: HomeModel(
                apiClient: .mock(fetchNumber: { 42 })
            ),
            router: RouterModel()
        )
    }
}
