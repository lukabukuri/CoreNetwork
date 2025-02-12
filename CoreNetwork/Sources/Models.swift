//
//  Models.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 17.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

/// Wrapper for empty decodable object
public struct EmptyData: Decodable {
    
    public private(set) var decoder: Decoder?
    public private(set) var data: Data?
   
    public init(from decoder: Decoder) {
        self.decoder = decoder
    }
    
    public init(data: Data) {
        self.data = data
    }

}

/// Media file model
public struct MediaFile {
    
    /// File name
    var key: String
    
    /// File data
    var data: Data
    
    /// File name with extension
    var name: String?
    
    /// File type (such as jpeg, gif, pdf...)
    var type: String?
    
    /// Creates an instance with given parameters
    ///
    /// - Parameters:
    ///   - key: File name
    ///   - data: File data
    ///   - name: File name with extension
    ///   - type: File type (such as jpeg, gif, pdf...)
    public init(key: String, data: Data, name: String? = nil, type: String? = nil) {
        self.key = key
        self.data = data
        self.name = name
        self.type = type
    }
    
}

/// Wrapper for network response
public struct AnyResponse {
    /// Response data
    public var data: Data
    
    /// An object that provides response metadata
    public var response: URLResponse?
}
