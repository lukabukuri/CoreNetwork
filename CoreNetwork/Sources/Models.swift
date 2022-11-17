//
//  Models.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 17.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

/// Wrapper for empty decodable object
public struct EmptyData: Decodable { }

public struct MediaFile {
    
    var key: String
    var data: Data
    var name: String?
    var type: String?
    
    public init(key: String, data: Data, name: String? = nil, type: String? = nil) {
        self.key = key
        self.data = data
        self.name = name
        self.type = type
    }
    
}
