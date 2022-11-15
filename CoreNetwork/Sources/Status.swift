//
//  Status.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 31.10.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

public extension CoreNetwork {
    
    enum Status: Error {
        case networkError(statusCode: Int)
        case badURL
        case encodingError
        case decodingError
        case couldNotMakeURLRequest
    }
    
}
