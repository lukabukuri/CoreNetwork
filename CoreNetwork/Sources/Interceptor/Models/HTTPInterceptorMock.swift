//
//  HTTPInterceptorMock.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 21.02.25.
//  Copyright © 2025 JSC TBC Bank. All rights reserved.
//

import Foundation

struct HTTPInterceptorMock {
    // General
    let url: URL
    let statusCode: Int?
    let httpMethod: String?
    
    // Request
    let requestHeaders: CoreNetwork.Headers?
    let requestQuery: CoreNetwork.Query?
    let requestBody: CoreNetwork.Body?
    
    // Response
    let responseHeaders: CoreNetwork.Headers?
    let responseBody: CoreNetwork.Body?
    
    init(
        url: URL,
        statusCode: Int? = nil,
        httpMethod: String? = nil,
        requestHeaders: CoreNetwork.Headers? = nil,
        requestQuery: CoreNetwork.Query? = nil,
        requestBody: CoreNetwork.Body? = nil,
        responseHeaders: CoreNetwork.Headers? = nil,
        responseBody: CoreNetwork.Body? = nil
    ) {
        self.url = url
        self.statusCode = statusCode
        self.httpMethod = httpMethod
        self.requestHeaders = requestHeaders
        self.requestQuery = requestQuery
        self.requestBody = requestBody
        self.responseHeaders = responseHeaders
        self.responseBody = responseBody
    }
}

extension HTTPInterceptorMock {
    var urlWithQueryParameters: URL {
        guard let query = requestQuery, !query.isEmpty else { return url }
        
        return URL(
            string: url.absoluteString + "?\(query.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))"
        )!
    }
}
