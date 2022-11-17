//
//  URLRequest+Extensions.swift.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

extension URLRequest {
    
    /// Creates and initializes a URL request with the given Endpoint model
    ///
    /// - Parameters:
    ///    - endpoint: Endpoint model for the request
    ///
    /// - Throws: `CoreNetwork.Status`
    public init(from endpoint: CoreNetwork.Endpoint) throws {
        
        guard let url = endpoint.constructURL() else { throw CoreNetwork.Status.badURL }
        
        self.init(url: url)
        
        try setParameters(headers: endpoint.headers, body: endpoint.body, method: endpoint.method, files: endpoint.files)
    }
    
    /// Sets given parameters to URLRequest
    ///
    /// - Parameters:
    ///    - headers: Field/value pairs of headers
    ///    - body: Body component for URLRequest
    ///    - method: HTTP method for URLRequest
    ///
    /// - Throws: `CoreNetwork.Status`
    private mutating func setParameters(headers: CoreNetwork.Headers,
                                        body: CoreNetwork.Body,
                                        method: CoreNetwork.HTTPMethod,
                                        files: [MediaFile]?) throws {
        
        httpMethod = method.rawValue
        
        for (headerField, headerValue) in headers {
            setValue(headerValue, forHTTPHeaderField: headerField)
        }
        
        if let files {
            let boundary = String.uuid
            setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            httpBody = createDataBody(withParameters: body, files: files, boundary: boundary)
        } else if !body.isEmpty {
            do {
                httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw CoreNetwork.Status.encodingError
            }
        }
    }
    
    private func createDataBody(withParameters parameters: CoreNetwork.Body, files: [MediaFile], boundary: String) -> Data {
        let lineBreak = "\r\n"
        
        var body = Data()
        
        for (key, value) in parameters {
            body.append(value: "--\(boundary + lineBreak)")
            body.append(value: "Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append(value: "\(value as! String + lineBreak)")
        }
        
        for file in files {
            body.append(value: "--\(boundary + lineBreak)")
            body.append(value: "Content-Disposition: form-data; name=\"\(file.key)\"\(file.name == nil ? "" : "; filename=\"\(file.name!)\"")\r\n")
            if let type = file.type {
                body.append(value: "Content-Type: \(type + lineBreak + lineBreak)")
            }
            body.append(file.data)
            body.append(value: lineBreak)
        }
        body.append(value: "--\(boundary)--\(lineBreak)")
        
        
        return body
    }

}
