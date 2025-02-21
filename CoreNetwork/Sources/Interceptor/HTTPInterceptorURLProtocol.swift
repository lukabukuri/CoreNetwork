//
//  HTTPInterceptorURLProtocol.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 21.02.25.
//  Copyright © 2025 JSC TBC Bank. All rights reserved.
//

import Foundation

final public class HTTPInterceptorURLProtocol: URLProtocol {
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.protocolClasses = []
        return URLSession(configuration: config)
    }()
    
    private lazy var logger: CoreNetwork.Logger = {
        let logger = CoreNetwork.Logger()
        logger.logLevel = .verbose
        return logger
    }()


    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func stopLoading() { }
    
    public override func startLoading() {
        session.dataTask(with: mockRequest()) { [weak self] data, response, error in
            guard let self else { return }
            
            if let error = error {
                logger.logError(error: error)
                self.client?.urlProtocol(self, didFailWithError: error)
                return
            }
            
            mockResponse(response: response, data: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }.resume()
    }
    
    // MARK: - Private Methods
    private func mockRequest() -> URLRequest {
        let mockItem = HTTPInterceptorMockManager.shared.getMock(by: { $0.url.path == self.request.url?.path })
        var request = self.request
        
        if let mockItem {
            request.url = mockItem.urlWithQueryParameters
            request.httpMethod = mockItem.httpMethod?.uppercased() ?? self.request.httpMethod
            
            if let requestHeaders = mockItem.requestHeaders {
                for (headerField, _) in self.request.allHTTPHeaderFields ?? [:] {
                    request.setValue(nil, forHTTPHeaderField: headerField)
                }
                
                for (headerField, headerValue) in requestHeaders {
                    request.setValue(headerValue, forHTTPHeaderField: headerField)
                }
            }
            
            if let requestBody = mockItem.requestBody,
               let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) {
                request.httpBody = httpBody
            }
        }
        
        logger.log(request)
        
        return request
    }
    
    private func mockResponse(response: URLResponse?, data: Data?) {
        if let httpResponse = response as? HTTPURLResponse,
           let mockResponse = HTTPInterceptorMockManager.shared.getMock(by: { $0.url.path == httpResponse.url?.path }) {
            
            if let modifiedResponse = HTTPURLResponse(
                url: mockResponse.urlWithQueryParameters,
                statusCode: mockResponse.statusCode ?? httpResponse.statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: mockResponse.responseHeaders ?? httpResponse.allHeaderFields as? [String: String]
            ) {
                logger.logResponse(response: modifiedResponse)
                self.client?.urlProtocol(self, didReceive: modifiedResponse, cacheStoragePolicy: .notAllowed)
            } else if let response {
                logger.logResponse(response: httpResponse)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let mockedResponseBody = mockResponse.responseBody,
               let modifiedData = try? JSONSerialization.data(withJSONObject: mockedResponseBody, options: []) {
                logger.logData(data: modifiedData)
                self.client?.urlProtocol(self, didLoad: modifiedData)
            } else if let data {
                logger.logData(data: data)
                self.client?.urlProtocol(self, didLoad: data)
            }
        } else {
            // Pass through the original response if no mocking is needed
            if let response = response {
                logger.logResponse(response: response as? HTTPURLResponse)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = data {
                logger.logData(data: data)
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
    }
}
