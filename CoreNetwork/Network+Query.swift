//
//  Network+Query.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//

import Foundation

public extension CoreNetwork {
    
    typealias Query = [String: String]
    
}

public extension CoreNetwork.Query {

    static var emptyQuery: CoreNetwork.Query { return [:] }
    
}

public extension CoreNetwork.Query {
    
    /// Creates URLQueryItem array from dictionary
    func urlQueryItems() -> [URLQueryItem] {
        map({ URLQueryItem(name: $0.key, value: $0.value) })
    }
    
}
