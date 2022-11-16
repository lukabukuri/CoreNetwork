//
//  URLRequest+Extensions.swift.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

extension URLRequest {
    
    /// Creates and initializes a URL request with the given Endpoint model
    ///
    /// - Parameters:
    ///    - endpoint: Endpoint model for the request
    ///
    /// - Throws: `CoreNetwork.Status`
    public init(from endpoint: CoreNetwork.Endpoint) throws {
        
        guard let url = endpoint.constructURL() else { throw CoreNetwork.Status.badURL }
        
        self.init(url: url)
        
        try setParameters(headers: endpoint.headers, body: endpoint.body, method: endpoint.method)
    }
    
    /// Sets given parameters to URLRequest
    ///
    /// - Parameters:
    ///    - headers: Field/value pairs of headers
    ///    - body: Body component for URLRequest
    ///    - method: HTTP method for URLRequest
    ///
    /// - Throws: `CoreNetwork.Status`
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
