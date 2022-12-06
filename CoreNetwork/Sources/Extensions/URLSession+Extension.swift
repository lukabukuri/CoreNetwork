//
//  URLSession+Extension.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 07.12.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    
    /// Replication of 'data(for:delegate:)' for targets before iOS 15.0
    ///
    /// Slightly modified for URLRequest instead of URL
    ///
    func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
    
}
