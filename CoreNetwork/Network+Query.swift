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
