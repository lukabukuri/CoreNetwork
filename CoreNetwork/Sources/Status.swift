//
//  Status.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 31.10.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

public extension CoreNetwork {
    
    /// Network error type
    ///
    /// ## Topics
    ///
    /// ### Errors
    ///
    /// - ``networkError(statusCode:)``
    /// - ``badURL``
    /// - ``encodingError``
    /// - ``decodingError``
    /// - ``couldNotMakeURLRequest``
    @frozen enum Status: Error {
        
        /// Network error with specific status code
        case networkError(statusCode: Int)
        
        /// URL can't be constructed from given components
        case badURL
        
        /// Object couldn't be encoded
        case encodingError
        
        /// JSON object couldn't be decoded into given type
        case decodingError
        
        /// Failed to make a URLRequest
        case couldNotMakeURLRequest
    }
    
}
