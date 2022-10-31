//
//  URLRequest.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//

import Foundation

extension URLRequest {
    
    public init(url: String, method: CoreNetwork.HTTPMethod, headers: CoreNetwork.Headers? = nil, body: CoreNetwork.Body? = nil) throws {
        guard let url = URL(string: url) else { throw NetworkError.badURL }
        
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        if method != .get, let body {
            httpBody = try JSONSerialization.data(withJSONObject: body)
        }
    }

}

public enum NetworkError: String, Error {
    case badURL
    case couldNotDecode
    case unknown
}
