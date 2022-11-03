//
//  URLRequest.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//

import Foundation

extension URLRequest {
    
    public init?(url: URL, method: CoreNetwork.HTTPMethod, headers: CoreNetwork.Headers? = nil, body: CoreNetwork.Body? = nil)  {
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        if let body {
            do {
                httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                return nil
            }
        }
    }

}
