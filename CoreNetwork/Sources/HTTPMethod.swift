//
//  HTTPMethod.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

extension CoreNetwork {
    
    public enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
}
