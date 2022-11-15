//
//  DTODecoder.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 03.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

struct DTODecoder {
    
    func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
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

public struct EmptyData: Decodable { }
