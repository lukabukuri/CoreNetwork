//
//  CoreNetwork+Headers.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//

import Foundation

public extension CoreNetwork {
    
    typealias Headers = [String : String]
    
}


public extension CoreNetwork.Headers {
    
    static var emptyHeaders: CoreNetwork.Headers { return [:] }
    
}
