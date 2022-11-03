//
//  Network+Status.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 31.10.22.
//

import Foundation

public extension CoreNetwork {
    enum Status: Error {
        case networkError(statusCode: Int)
        case badURL
        case encodingError
        case decodingError
    }
}
