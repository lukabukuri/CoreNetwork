//
//  XCTestCase+Extensions.swift
//  CoreNetworkTests
//
//  Created by Mishka Chargazia on 17.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import XCTest

extension XCTest {
    func XCTAssertThrowsError<T: Sendable>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
