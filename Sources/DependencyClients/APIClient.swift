import FVendors
import Foundation
import Models

/// API 客户端
///
/// 提供对后端 API 的访问接口
public struct APIClient: Sendable {
    private let networkClient: NetworkClient

    /// 初始化 API 客户端
    /// - Parameter networkClient: 网络客户端
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    /// 获取随机数字
    /// - Returns: Number 对象
    public func fetchNumber() async throws -> Number {
        let url = URL(string: "https://api.example.com/number")!
        let request = APIRequestBuilder.buildRequest(
            url: url,
            method: .get,
            headers: ["Content-Type": "application/json"]
        )

        struct Response: Codable {
            let value: Int
        }

        let response = try await networkClient.request(request, as: Response.self)
        return Number(integerLiteral: response.value)
    }
}

// MARK: - 测试辅助

extension APIClient {
    /// Mock 实现（用于测试）
    /// - Parameter fetchNumber: 模拟的 fetchNumber 闭包
    /// - Returns: APIClient 实例
    public static func mock(
        fetchNumber: @escaping @Sendable () async throws -> Number
    ) -> APIClient {
        let mockNetwork = NetworkClient.mock { _ in
            let number = try await fetchNumber()
            struct Response: Codable {
                let value: Int
            }
            let response = Response(value: number.rawValue)
            return try JSONEncoder().encode(response)
        }
        return APIClient(networkClient: mockNetwork)
    }
}
