import Foundation
import CoreNetwork

final class Network: CoreNetwork {
    
    static let shared = Network()
    
    init(configuration: URLSessionConfiguration = .shared) {
        super.init(configuration: configuration)
    }
    
    func request<T: Decodable>(url: String,
                               path: String,
                               headers: Headers = .emptyHeaders,
                               query: Query = .emptyQuery,
                               body: Body = .emptyBody,
                               method: HTTPMethod = .get,
                               type: T.Type) async throws -> T {
        
        let endpoint = Endpoint(scheme: .https,
                                host: url,
                                path: path,
                                query: query,
                                method: method,
                                headers: headers,
                                body: body)
        
        let (data, response) = try await request(endpoint: endpoint, type: type)
        
        return data
    }

}
