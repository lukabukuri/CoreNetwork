//
//  URLRequest.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//

import Foundation

extension URLRequest {
    
    /// Creates and initializes a URL request with the given Endpoint model
    ///
    /// - Parameters:
    ///    - endpoint: Endpoint model for the request
    ///
    /// - Throws: badURL if URL can't be constructed using
    public init?(from endpoint: CoreNetwork.Endpoint) throws {
        let urlComponents = endpoint.urlComponents()
        guard let url = urlComponents.url else { throw CoreNetwork.Status.badURL }
        
        self.init(url: url)
        
        try setParameters(headers: endpoint.headers, body: endpoint.body, method: endpoint.method)
    }
    
    private mutating func setParameters(headers: CoreNetwork.Headers,
                                        body: CoreNetwork.Body,
                                        method: CoreNetwork.HTTPMethod) throws {
        
        httpMethod = method.rawValue
        
        for (headerField, headerValue) in headers {
            setValue(headerValue, forHTTPHeaderField: headerField)
        }
        
        if !body.isEmpty {
            do {
                httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw CoreNetwork.Status.encodingError
            }
        }
    }
}
