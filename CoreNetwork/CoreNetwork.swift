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
                                                 success: ((T) -> Void)? = nil,
                                                 fail: (() -> Void)? = nil,
                                                 unauthorized: (() -> Void)? = nil) {
        
        
        let url = generateURL(baseURL: url, path: path, query: query)
        
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers, body: body)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                    fail?(); return }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        success?(result)
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        fail?()
                    }
                }
            }.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private static func generateURL(baseURL: String, path: String, query: Query) -> String {
        var path = path
        if !query.isEmpty {
            path += "?\(query.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))"
        }
        let allowedCharacterSet = CharacterSet.urlHostAllowed.union(.urlPathAllowed).union(.urlQueryAllowed)
        if let encoded = path.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            path = encoded
        }
        
        return baseURL + path
        
    }
}
