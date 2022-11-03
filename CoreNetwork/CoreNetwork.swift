//
//  CoreNetwork.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 26.10.22.
//

import Foundation

public class CoreNetwork {
    
    public class func request<T: Decodable>(endpoint: Endpoint,
                                            type: T.Type,
                                            completion: @escaping ((Result<T, Status>) -> Void) = { _ in }) {
        var urlRequest: URLRequest?
        
        do {
            urlRequest = try URLRequest(from: endpoint)
        } catch {
            if let error = error as? Status {
                completion(.failure(error))
                return
            }
        }
        
        guard let urlRequest else { completion(.failure(.unknown)) ; return }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
