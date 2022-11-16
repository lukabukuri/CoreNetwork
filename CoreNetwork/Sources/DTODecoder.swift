//
//  DTODecoder.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 03.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

/// Decoder for data transfer object
struct DTODecoder {
    
    /// Decodes data transfer object
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode from the supplied JSON object.
    ///   - data: JSON object to be decoded
    ///
    /// - Returns: Decoded object of given type if decoding is successful
    func decode<T>(type: T.Type, data: Data) -> T? where T : Decodable {
        if type == Data.self, let data = data as? T {
            return data
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

/// Wrapper for empty decodable object
public struct EmptyData: Decodable { }
