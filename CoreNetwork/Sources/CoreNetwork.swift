//
//  CoreNetwork.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 26.10.22.
//

import Foundation

public class CoreNetwork {
    
    private var urlSession: URLSession
    
    init(urlSessionConfiguration: URLSessionConfiguration) {
        self.urlSession = URLSession(configuration: urlSessionConfiguration)
    }

    
    func request<T: Decodable>(endpoint: Endpoint, type: T.Type = EmptyData.self) async throws -> T {
        
        guard let urlRequest = try? URLRequest(from: endpoint) else { throw CoreNetwork.Status.couldNotMakeURLRequest}
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        
        guard (200..<300).contains(statusCode) else { throw CoreNetwork.Status.networkError(statusCode: statusCode) }
        
        guard let data = DTODecoder().decode(type: type, data: data) else { throw CoreNetwork.Status.decodingError}
        
        return data
    }
    
    @available(*, deprecated, message: "Use async/await request instead")
    class func request<T: Decodable>(endpoint: Endpoint,
                                     type: T.Type = EmptyData.self,
                                     urlSessionConfiguration: URLSessionConfiguration = .default,
                                     completion: @escaping ((Result<T, Status>) -> Void) = { _ in }) {
        
        guard let urlRequest = try? URLRequest(from: endpoint) else {
            return completion(.failure(.couldNotMakeURLRequest)) }
        
        URLSession(configuration: urlSessionConfiguration).dataTask(with: urlRequest) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            
            guard error == nil, let data, (200..<300).contains(statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(statusCode: statusCode)))
                }
                return
            }
             
            DispatchQueue.main.async {
                if let data = DTODecoder().decode(type: type, data: data) {
                    completion(.success(data))
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
