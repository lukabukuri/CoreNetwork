//
//  URLParameters.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 14.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

public extension CoreNetwork {
    
    typealias Headers = [String : String]
    typealias Query = [String: String]
    typealias Body = [String: Any]
    
}

public extension CoreNetwork.Headers {
    
    static var emptyHeaders: CoreNetwork.Headers { return [:] }
    
}

public extension CoreNetwork.Query {
    
    static var emptyQuery: CoreNetwork.Query { return [:] }
    
    /// Creates URLQueryItem array from dictionary
    func urlQueryItems() -> [URLQueryItem] {
        map({ URLQueryItem(name: $0.key, value: $0.value) })
    }
    
}

public extension CoreNetwork.Body {
    
    static var emptyBody: CoreNetwork.Body { return [:] }
    
}
