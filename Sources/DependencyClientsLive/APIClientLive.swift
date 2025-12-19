import DependencyClients
import FVendors
import Foundation
import Models

extension APIClient {
    /// 生产环境的 API 客户端实现（使用真实网络请求）
    public static let live = APIClient(networkClient: .live)
}
