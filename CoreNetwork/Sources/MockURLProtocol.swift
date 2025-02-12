//
//  MockURLProtocol.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 14.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

final public class MockURLProtocol: URLProtocol {
    
    /// Dictionary to store handlers for different URLs
    private static var requestHandlers: [String: (URLRequest) throws -> (HTTPURLResponse, Data?)] = [:]
    private static let handlerQueue = DispatchQueue(label: "com.mockURLProtocol.handlerQueue")

    public override class func canInit(with request: URLRequest) -> Bool {
        // Check if this protocol can handle the given request.
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Return the canonical version of the request.
        return request
    }
    
    public override func startLoading() {
        guard let url = request.url?.path else {
            fatalError("Request URL is missing.")
        }
        
        // Dispatch to a background queue to handle the request concurrently.
        DispatchQueue.global().async {
            MockURLProtocol.handlerQueue.sync {
                guard let handler = MockURLProtocol.requestHandlers[url] else {
                    fatalError("Handler for \(url) is unavailable.")
                }
                
                do {
                    // Call handler with the received request and capture the response and data.
                    let (response, data) = try handler(self.request)
                    
                    // Send received response to the client.
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                    
                    if let data = data {
                        // Send received data to the client.
                        self.client?.urlProtocol(self, didLoad: data)
                    }
                    
                    // Notify request has been finished.
                    self.client?.urlProtocolDidFinishLoading(self)
                } catch {
                    // Notify received error.
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            }
        }
    }
    
    public override func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
    
    /// Sets the request handler for a specific URL.
    public static func setRequestHandler(for url: String, handler: @escaping (URLRequest) throws -> (HTTPURLResponse, Data?)) {
        handlerQueue.sync {
            requestHandlers[url] = handler
        }
    }
    
    /// Clears all request handlers.
    public static func clearRequestHandlers() {
        handlerQueue.sync {
            requestHandlers.removeAll()
        }
    }
}

