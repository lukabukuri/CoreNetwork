//
//  HTTPInterceptorMockManager.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 21.02.25.
//  Copyright © 2025 JSC TBC Bank. All rights reserved.
//

import Foundation

final class HTTPInterceptorMockManager {
    static let shared = HTTPInterceptorMockManager()
    
    private var mocks = [HTTPInterceptorMock]()
    private let queue = DispatchQueue(label: "com.example.HTTPInterceptorMockManagerQueue")

    private init() {}
    
    func addMock(mock: HTTPInterceptorMock) {
        queue.async {
            self.mocks.append(mock)
        }
    }

    func getMocks() -> [HTTPInterceptorMock] {
        return queue.sync {
            return self.mocks
        }
    }

    func getMock(by criteria: (HTTPInterceptorMock) -> Bool) -> HTTPInterceptorMock? {
        return queue.sync {
            return self.mocks.first(where: criteria)
        }
    }

    func removeMock(by criteria: @escaping (HTTPInterceptorMock) -> Bool) {
        queue.async {
            self.mocks.removeAll(where: criteria)
        }
    }
}
