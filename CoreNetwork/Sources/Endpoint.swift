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
        
        
        /// Body Object
        ///
        /// - Encodable object for message body of a request, such as for an HTTP POST request
        var bodyObject: Encodable?
        
        
        /// Files
        ///
        /// - Array of media files (such as jpeg, gif, pdf...)
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
        ///   - bodyObject: Encodable object for message body of a request, such as for an HTTP POST request
        ///   - files: rray of media files (such as jpeg, gif, pdf...)
        public init(scheme: Scheme = .defaultScheme, host: String, path: String, query: Query, method: HTTPMethod, headers: Headers, body: Body, bodyObject: Encodable? = nil, files: [MediaFile]? = nil) {
            self.scheme = scheme
            self.host = host
            self.path = path
            self.query = query
            self.method = method
            self.headers = headers
            self.body = body
            self.bodyObject = bodyObject
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
        
        case empty
        
        /// Value
        ///
        /// - String value for scheme subcomponent
        public var value: String {
            switch self {
            case .https, .http:
                return "\(name)://"
            case .custom(let value):
                return value
            case .empty:
                return ""
            }
        }
        
        /// Name
        public var name: String {
            switch self {
            case .https:
                return "https"
            case .http:
                return "http"
            case .custom(let value):
                return value
            case .empty:
                return ""
            }
        }
        
        /// Default scheme
        ///
        /// - Set to https by default
        public static let defaultScheme: Self = .empty
    }
    
}

public extension CoreNetwork.Endpoint {

    /// Host subcomponent combined with path
    private var hostWithPath: String {
        let path = !path.hasPrefix("/") && !path.isEmpty ? "/".appending(path) : path
        
        guard !host.isEmpty else { return path }
        
        if path.isEmpty {
            return host
        } else if !host.hasSuffix("/") {
            return host + path
        } else {
            var host = host
            if !path.isEmpty {
                host.removeLast()
            }
            return host + path
        }
    }

    
    /// Creates URL from given subcomponents of endpoint
    var url: URL? {
        let allowedCharacterSet = CharacterSet.urlHostAllowed.union(.urlPathAllowed).union(.urlQueryAllowed)
        let urlString = scheme.value + hostWithPath + (!query.isEmpty ? "?\(query.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))" : "")
        
        guard let url = urlString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else { return nil }
        
        return URL(string: url)
    }
}

