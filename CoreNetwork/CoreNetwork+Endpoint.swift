//
//  CoreNetwork+Endpoint.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 03.11.22.
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
        var host: String?
        
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
        var headers: Headers = .defaultHeaders
        
        /// Body
        ///
        /// - A dictionary of the data sent as the message body of a request, such as for an HTTP POST request
        var body: Body = .emptyBody
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
    
    /// Creates URLComponents object from given subcomponents of endpoint
    func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.value
        urlComponents.path = path
        urlComponents.host = host
        urlComponents.queryItems = query.urlQueryItems()
        
        return urlComponents
    }
    
}
