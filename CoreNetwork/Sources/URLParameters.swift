//
//  URLParameters.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 14.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

public extension CoreNetwork {
    
    /// Dictionary for URLRequest header component
    typealias Headers = [String : String]
    
    /// Dictionary for URLRequest query component
    typealias Query = [String : Any]
    
    /// Dictionary for URLRequest body component
    typealias Body = [String : Any]
    
    /// Dictionary for JSON object
    typealias JSON = [String : Any]
    
    /// Array of JSON objects
    typealias JSONArray = [[String : Any]]
    
}

public extension CoreNetwork.Headers {
    
    /// Empty dictionary for `Headers`
    static var emptyHeaders: CoreNetwork.Headers { return [:] }
    
}

public extension CoreNetwork.Query {
    
    /// Empty dictionary for `Query`
    static var emptyQuery: CoreNetwork.Query { return [:] }
    
}

public extension CoreNetwork.Body {
    
    /// Empty dictionary for `Body`
    static var emptyBody: CoreNetwork.Body { return [:] }
    
}
