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
        
        
        var files: [MediaFile]?
        
        /// Creates an instance with given components
        ///
        /// - Parameters:
        ///   - scheme: URL ``Scheme`` subcomponent
        ///   - host: The host subcomponent of the URL
        ///   - path: The path subcomponent of the URL
        ///   - query: The query URL component
        ///   - method: The HTTP request method of type `HTTPMethod`
        ///   - headers: A dictionary containing the HTTP header fields for a request
        ///   - body: A dictionary of the data sent as the message body of a request, such as for an HTTP POST request
        public init(scheme: Scheme, host: String, path: String, query: Query, method: HTTPMethod, headers: Headers, body: Body, files: [MediaFile]? = nil) {
            self.scheme = scheme
            self.host = host
            self.path = path
            self.query = query
            self.method = method
            self.headers = headers
            self.body = body
            self.files = files
        }
    }
    
}

public extension CoreNetwork.Endpoint {
    
    /// URL Scheme subcomponent
    @frozen enum Scheme {
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
        public var value: String {
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
        public static let defaultScheme: Self = .https
    }
    
}

public extension CoreNetwork.Endpoint {
    
    /// Creates URLComponents object from given subcomponents of endpoint
    func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.value
        
        if let url = URL(string: scheme.value.appending("://\(host)")) {
            urlComponents.host = url.host
            urlComponents.port = url.port
            urlComponents.path = url.path.appending(path.normalizedURLPath())
        }
        
        urlComponents.queryItems = query.isEmpty ? nil : query.urlQueryItems()
        
        return urlComponents
    }
    
}

