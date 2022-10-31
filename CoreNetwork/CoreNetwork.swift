//
//  CoreNetwork.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 26.10.22.
//

import Foundation

public class CoreNetwork {
    
    public static weak var delegate: CoreNetworkProtocol?
    
    public static func jsonRequest<T: Decodable>(url: String = delegate?.baseURL ?? "",
                                                 path: String,
                                                 headers: Headers = delegate?.headers ?? .emptyHeaders,
                                                 query: Query = .emptyQuery,
                                                 body: Body = .emptyBody,
                                                 method: HTTPMethod = .get,
                                                 type: T.Type,
                                                 completion: @escaping ((Result<T, Status>) -> Void) = { _ in }) {
        
        
        guard let url = generateURL(baseURL: url, path: path, query: query) else {
            completion(.failure(.incorrectURL))
            return
        }
        
        guard let urlRequest = URLRequest(url: url, method: method, headers: headers, body: body) else {
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard error == nil,
                  let data,
                  (200..<300).contains(statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(statusCode: statusCode)))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    private static func generateURL(baseURL: String, path: String, query: Query) -> URL? {
        var path = path
        if !query.isEmpty {
            path += "?\(query.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))"
        }
        let allowedCharacterSet = CharacterSet.urlHostAllowed.union(.urlPathAllowed).union(.urlQueryAllowed)
        if let encoded = path.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            path = encoded
        }
        
        return URL(string: baseURL + path)
        
    }
}
