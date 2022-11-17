//
//  CoreNetworkTests.swift
//  CoreNetworkTests
//
//  Created by Luka Bukuri on 26.10.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import XCTest
@testable import CoreNetwork

final class CoreNetworkTests: XCTestCase {
    
    var sut: CoreNetwork!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        sut = CoreNetwork(configuration: configuration)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testRequestSuccess() throws {
        // Given
        let mockData = "Test Data".data(using: .utf8)
        let mockURL = "stfu.com"
        
        let endpoint = CoreNetwork.Endpoint(scheme: .defaultScheme,
                                            host: mockURL,
                                            path: "",
                                            query: .emptyQuery,
                                            method: .get,
                                            headers: .emptyHeaders,
                                            body: .emptyBody,
                                            files: [])
        
        MockURLProtocol.requestHandler =  { request in
            guard let url = request.url else { throw CoreNetwork.Status.badURL }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil) else { throw CoreNetwork.Status.couldNotMakeURLRequest }
            return (response, mockData)
        }
        
        // When
        let expectation = self.expectation(description: "Network request with success response")
        
        Task {
            let data = try await sut.request(endpoint: endpoint, type: Data.self)
            
            XCTAssertEqual(data.0, mockData)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testRequestFailureNetworkError() throws {
        // Given
        let mockData = "Test Data".data(using: .utf8)
        let mockURL = "stfu.com"
        
        let endpoint = CoreNetwork.Endpoint(scheme: .defaultScheme,
                                            host: mockURL,
                                            path: "",
                                            query: .emptyQuery,
                                            method: .get,
                                            headers: .emptyHeaders,
                                            body: .emptyBody)
        
        MockURLProtocol.requestHandler =  { request in
            guard let url = request.url else { throw CoreNetwork.Status.badURL }
            guard let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: "2.0", headerFields: nil) else { throw CoreNetwork.Status.couldNotMakeURLRequest }
            return (response, mockData)
        }
        
        // When
        let expectation = self.expectation(description: "Network request with failure response")
        
        Task {
            await XCTAssertThrowsError(try await sut.request(endpoint: endpoint, type: Data.self),
                                       "Should throw networking error with status code 401") { error in
                XCTAssertEqual(CoreNetwork.Status.networkError(statusCode: 401), error as? CoreNetwork.Status)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testRequestFailureDecodingError() throws {
        // Given
        let mockData = "Test Data".data(using: .utf8)
        let mockURL = "stfu.com"
        
        let endpoint = CoreNetwork.Endpoint(scheme: .defaultScheme,
                                            host: mockURL,
                                            path: "",
                                            query: .emptyQuery,
                                            method: .get,
                                            headers: .emptyHeaders,
                                            body: .emptyBody)
        
        MockURLProtocol.requestHandler =  { request in
            guard let url = request.url else { throw CoreNetwork.Status.badURL }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil) else { throw CoreNetwork.Status.couldNotMakeURLRequest }
            return (response, mockData)
        }
        
        // When
        let expectation = self.expectation(description: "Network request with failure response")
        
        Task {
            await XCTAssertThrowsError(try await sut.request(endpoint: endpoint, type: String.self),
                                       "Should throw decoding error") { error in
                XCTAssertEqual(CoreNetwork.Status.decodingError, error as? CoreNetwork.Status)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testRequestCompletionBasedSuccess() throws {
        // Given
        let mockData = "Test Data".data(using: .utf8)
        let mockURL = "stfu.com"
        
        let endpoint = CoreNetwork.Endpoint(scheme: .defaultScheme,
                                            host: mockURL,
                                            path: "",
                                            query: .emptyQuery,
                                            method: .get,
                                            headers: .emptyHeaders,
                                            body: .emptyBody)
        
        MockURLProtocol.requestHandler =  { request in
            guard let url = request.url else { throw CoreNetwork.Status.badURL }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil) else { throw CoreNetwork.Status.couldNotMakeURLRequest }
            return (response, mockData)
        }
        
        // When
        let expectation = self.expectation(description: "Network request with success response")
        
        sut.request(endpoint: endpoint, type: Data.self) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.0, mockData)
            case .failure(let error):
                XCTFail("Request should have success response.\nfailure reason: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testRequestCompletionBasedFailureNetworkError() throws {
        // Given
        let mockData = "Test Data".data(using: .utf8)
        let mockURL = "stfu.com"
        
        let endpoint = CoreNetwork.Endpoint(scheme: .defaultScheme,
                                            host: mockURL,
                                            path: "",
                                            query: .emptyQuery,
                                            method: .get,
                                            headers: .emptyHeaders,
                                            body: .emptyBody)
        
        MockURLProtocol.requestHandler =  { request in
            guard let url = request.url else { throw CoreNetwork.Status.badURL }
            guard let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: "2.0", headerFields: nil) else { throw CoreNetwork.Status.couldNotMakeURLRequest }
            return (response, mockData)
        }
        
        // When
        let expectation = self.expectation(description: "Network request with failure response")
        
        sut.request(endpoint: endpoint, type: Data.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request was expected to fail")
            case .failure(let error):
                XCTAssertEqual(error, CoreNetwork.Status.networkError(statusCode: 401))
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testRequestCompletionBasedFailureDecodingError() throws {
        // Given
        let mockData = "Test Data".data(using: .utf8)
        let mockURL = "stfu.com"
        
        let endpoint = CoreNetwork.Endpoint(scheme: .defaultScheme,
                                            host: mockURL,
                                            path: "",
                                            query: .emptyQuery,
                                            method: .get,
                                            headers: .emptyHeaders,
                                            body: .emptyBody)
        
        MockURLProtocol.requestHandler =  { request in
            guard let url = request.url else { throw CoreNetwork.Status.badURL }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil) else { throw CoreNetwork.Status.couldNotMakeURLRequest }
            return (response, mockData)
        }
        
        // When
        let expectation = self.expectation(description: "Network request with failure response")
        
        sut.request(endpoint: endpoint, type: String.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request was expected to fail")
            case .failure(let error):
                XCTAssertEqual(error, CoreNetwork.Status.decodingError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testEndpoint() throws {
        // Given
        let mockData = Data()
        let mockScheme: CoreNetwork.Endpoint.Scheme = .https
        let mockHost = "stfu.com"
        let mockQuery: CoreNetwork.Query = ["flacko" : "jodye"]
        let path = "/weee"
        let mockHeraders: CoreNetwork.Headers = ["head" : "ers"]
        
        let endpoint = CoreNetwork.Endpoint(scheme: .https,
                                            host: mockHost,
                                            path: path,
                                            query: mockQuery,
                                            method: .post,
                                            headers: mockHeraders,
                                            body: .emptyBody)
        
        MockURLProtocol.requestHandler =  { request in
            // Then
            guard let url = request.url else {
                XCTFail("Invalid URL passed to request")
                throw CoreNetwork.Status.badURL
            }
            
            guard let query = request.url?.getQueries(),
                  query == mockQuery else {
                XCTFail("Invalid query attached to request")
                throw CoreNetwork.Status.badURL
            }
            
            XCTAssertEqual(request.httpMethod, "POST", "Incorrect HTTP method set to request")
            XCTAssertEqual(mockScheme.value, request.url?.scheme, "Incorrect scheme set to URL")
            XCTAssertEqual(mockHost, request.url?.host, "Incorrect host passed to URL")
            XCTAssertEqual(request.url?.path, path, "Incorrect path attached to URL")
            
            mockHeraders.forEach { header in
                XCTAssertTrue(request.allHTTPHeaderFields?.contains(where: { $0 == header }) ?? false, "Header field/value missing in request: \(header)")
            }
            
            guard let httpURLResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil) else {
                throw CoreNetwork.Status.couldNotMakeURLRequest
            }
            
            return (httpURLResponse, mockData)
        }
        
        // When
        let expectation = self.expectation(description: "Network request with any response")
        Task {
            _ = try await sut.request(endpoint: endpoint, type: Data.self)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
    }

}
