//
//  Endpoint.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 03.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

public extension CoreNetwork {
    
    /// Endpoint model for request
    struct Endpoint {
        /// Scheme
        ///
        /// - The scheme subcomponent of the URL
        var scheme: Scheme = .defaultScheme
        
        /// Host
        ///
        /// - The host subcomponent of the URL
        ///
        /// - Note: Nullable
        var host: String
        
        /// Path
        ///
        /// - The path subcomponent of the URL
        var path: String
        
        /// Query
        ///
        ///  - query URL component
        var query: Query = .emptyQuery
        
        /// Method
        ///
        /// - The HTTP request method
        var method: HTTPMethod = .get
        
        /// Headers
        ///
        /// - A dictionary containing the HTTP header fields for a request
        var headers: Headers = .emptyHeaders
        
        /// Body
        ///
        /// - A dictionary of the data sent as the message body of a request, such as for an HTTP POST request
        var body: Body = .emptyBody
        
        public init(scheme: Scheme, host: String, path: String, query: Query, method: HTTPMethod, headers: Headers, body: Body) {
            self.scheme = scheme
            self.host = host
            self.path = path
            self.query = query
            self.method = method
            self.headers = headers
            self.body = body
        }
    }
    
}

public extension CoreNetwork.Endpoint {
    
    /// URL Scheme subcomponent
    enum Scheme {
        /// HTTPS
        ///
        /// - String value: "https"
        case https
        
        /// HTTP
        ///
        /// - String value: "http"
        case http
        
        /// Custom scheme
        ///
        /// - String value returns the string given in the associated parameter
        /// - Parameter value: Custom value for scheme subcomponent
        case custom(value: String)
        
        /// Value
        ///
        /// - String value for scheme subcomponent
        var value: String {
            switch self {
            case .https:
                return "https"
            case .http:
                return "http"
            case .custom(let value):
                return value
            }
        }
        
        /// Default scheme
        ///
        /// - Set to https by default
        static let defaultScheme: Self = .https
    }
    
}

public extension CoreNetwork.Endpoint {
    
    /// Creates URL object from given subcomponents of endpoint
    func constructURL() -> URL? {
        var url = scheme.value + ":" + host + path.normalizedURLPath()
        if !query.isEmpty {
            url += "?\(query.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))"
        }

        return URL(string: url)
    }
    
}
