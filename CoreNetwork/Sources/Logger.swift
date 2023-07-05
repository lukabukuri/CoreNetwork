//
//  Logger.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 18.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

public extension CoreNetwork {
    
    /// Console logger for network requests and responses
    final class Logger {
        
        /// Determines logging state using `Level` enum
        var logLevel: Level = .off
        
        /// URL Predecates
        var urlPredicates: [NSPredicate] = []
        
        /// Custom logging option for request
        var customRequestLogger: ((URLRequest) -> ())?
        
        /// Custom logging option for response
        var customResponseLogger: ((HTTPURLResponse?, Data?, Error?) -> ())?
        
        /// Date format
        ///
        /// Example: 2022-11-18 15:23:05.0730
        private let dateFormat = "y-MM-dd H:mm:ss.SSSS"
        
        /// Logs request details if evaluated as eligible for logging
        ///
        /// - Parameters:
        ///    - request: URLRequest object
        func log(_ request: URLRequest) {
            guard evaluateURL(request.url?.absoluteString ?? "") else { return }
            
            guard customRequestLogger == nil else {
                customRequestLogger?(request)
                return
            }
            
            let urlDescription = "URL: \(request.url?.absoluteString ?? "N/A")"
            let methodDescription = "METHOD: \(request.httpMethod?.description ?? "N/A")"
            
            switch logLevel {
            case .off, .debug:
                break
            case .verbose:
                print(urlDescription)
                print(methodDescription)
                
                let df = DateFormatter()
                df.dateFormat = dateFormat
                print("Request date:", df.string(from: Date()))
                
                if let headers = request.allHTTPHeaderFields,
                   let data = try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted) {
                    print("Request headers:\n\(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "N/A")")
                }
                
                if let data = request.httpBody,
                   let json = try? JSONSerialization.jsonObject(with: data),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    print("Request body:\n:\(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? "N/A")")
                }
            case .info:
                print(urlDescription)
                print(methodDescription)
            }
        }
        
        /// Logs response details if evaluated as eligible for logging
        ///
        /// - Parameters:
        ///    - response: HTTPURLResponse object
        ///    - data: Data object of request response
        ///    - error: `Error` occured during request
        func log(_ response: HTTPURLResponse?, data: Data?, error: Error?) {
            guard evaluateURL(response?.url?.absoluteString ?? "") else { return }
            
            guard customResponseLogger == nil else {
                customResponseLogger?(response, data, error)
                return
            }
            
            let urlDescription = "URL: \(response?.url?.absoluteString ?? "N/A")"
            let statusCodeDescription = "Status code: \(response?.statusCode ?? -1)"
            
            switch logLevel {
            case .off:
                return
            case .verbose, .debug:
                print(urlDescription)
                print(statusCodeDescription)
                
                let df = DateFormatter()
                df.dateFormat = dateFormat
                print("Response date:", df.string(from: Date()))
                
                if let error {
                    print("Error:", error.localizedDescription)
                    return
                }
                print("Response type:", response?.mimeType ?? "N/A")
                
                if let data,
                   let json = try? JSONSerialization.jsonObject(with: data),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    print("Response JSON:\n\(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? "N/A")")
                } else if let data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "N/A")
                }
            case .info:
                print(urlDescription)
                print(statusCodeDescription)
            }
        }
        
        /// Evaluates if url matches given predicates
        ///
        /// - Returns: `Boolean`, true if no predicates are provided or URL matches any of the predicates
        private func evaluateURL(_ url: String) -> Bool {
            return urlPredicates.isEmpty || urlPredicates.contains(where: { $0.evaluate(with: url) })
        }
        
    }
}

public extension CoreNetwork.Logger {
    
    /// Logging level
    ///
    /// ## Topics:
    ///
    /// ### Levels
    ///
    /// - ``off``
    /// - ``debug``
    /// - ``info``
    @frozen enum Level {
        /// Logging  disabled
        case off
        
        /// Logs URL, response status code, response data type and response
        case debug
        
        /// Logs URL, HTTP method, headers, body, response status code, response data type and response
        case verbose
        
        /// Logs URL, HTTP method, response status code
        case info
    }
    
}
