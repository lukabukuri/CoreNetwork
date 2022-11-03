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
        var urlComponents = endpoint.urlComponents()
        guard let url = urlComponents.url else { throw CoreNetwork.Status.badURL }
        
        self.init(url: url)
        
        set(headers: endpoint.headers)
        try set(body: endpoint.body)
    }
    
    /// Set HTTP headers from given endpoint
    ///
    /// - Note: Will replace values if any of the given header fields already exist
    public mutating func set(headers: CoreNetwork.Headers) {
        for (headerField, headerValue) in headers {
            setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }
    
    /// Set HTTP body if exists
    ///
    /// - Throws: encodingError if JSON data can't be serialized from given object
    public mutating func set(body: CoreNetwork.Body) throws {
        if !body.isEmpty {
            do {
                httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw CoreNetwork.Status.encodingError
            }
        }
    }

}
