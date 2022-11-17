//
//  URL+Extensions.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 17.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

extension URL {
    
    /// Get queries as a dictionary from url
    ///
    /// - Returns: Dictionary `[String: String?]?` consisting of query name-value pairs, will return nil if `URLComponents` can't be constructed from the given URL
    func getQueries() -> [String : String?]? {
        guard let urlComponents = URLComponents(string: self.absoluteString) else { return nil }
        return urlComponents.queryItems?.reduce(into: [String: String](), { result, item in
            result[item.name] = item.value
        })
    }
    
}
