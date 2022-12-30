//
//  CoreNetwork.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 26.10.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

open class CoreNetwork {
    
    /// URLSession object
    private let urlSession: URLSession
    
    /// SessionDelegate object
    public var delegate: SessionDelegate
    
    /// Logger
    private var logger: Logger?
    
    /// Creates and initializes an instance and with given URLSessionConfiguration and ``SessionDelegate``
    ///
    /// - Parameters:
    ///   - configuration: A configuration object that specifies certain behaviors of URLSession
    ///   - delegate: A session delegate object that handles requests for authentication and other session-related events.
    public init(configuration: URLSessionConfiguration,
                delegate: SessionDelegate = SessionDelegate()) {
        self.delegate = delegate
        self.urlSession = URLSession(configuration: configuration,
                                     delegate: delegate,
                                     delegateQueue: nil)
    }
    
    /// Makes async network request using given endpoint object
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint model for the request
    ///   - type: Generic type for decoding response, defaults to ``EmptyData``
    ///
    /// - Throws: An error of type `CoreNetwork.NetworkError`
    /// - Returns: Object of generic type passed as a parameter
    public func request<T>(endpoint: Endpoint,
                         type: T.Type = EmptyData.self)
    async throws -> (T, HTTPURLResponse?) where T : Decodable {
        
        let urlRequest = try URLRequest(from: endpoint)
        logger?.log(urlRequest)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        logger?.log(response as? HTTPURLResponse, data: data, error: nil)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        
        guard (200..<300).contains(statusCode) else { throw CoreNetwork.NetworkError.error(statusCode: statusCode) }
        
        guard let data = DTODecoder.decode(type: type, data: data) else { throw CoreNetwork.NetworkError.decodingError}
        
        return (data, response as? HTTPURLResponse)
    }
    
    /// Makes completion based network request using given endpoint object
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint model for the request
    ///   - type: Generic type for decoding response, defaults to ``EmptyData``
    ///   - completion: The completion handler with Result parameter to call when the network request is complete.
    ///     - Result with associated type: generict type for success and `Status` error type for failure
    @available(*, deprecated, message: "Use async/await request instead")
    public func request<T>(endpoint: Endpoint,
                         type: T.Type = EmptyData.self,
                         completion: @escaping ((Result<(T, HTTPURLResponse?), NetworkError>) -> Void) = { _ in }) where T : Decodable {
        
        guard let urlRequest = try? URLRequest(from: endpoint) else {
            return completion(.failure(.couldNotMakeURLRequest)) }
        
        logger?.log(urlRequest)
        
        self.urlSessionDataTask(urlRequest: urlRequest, completion: { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let data = DTODecoder.decode(type: type, data: response.data) {
                        completion(.success((data, response as? HTTPURLResponse)))
                    } else {
                        completion(.failure(.decodingError))
                    }
                }
            case .failure(let status):
                DispatchQueue.main.async {
                    completion(.failure(status))
                }
            }
            
        })
    }
    
    public func request(urlRequest: URLRequest,
                      completion: @escaping ((Result<AnyResponse, NetworkError>) -> Void) = { _ in }) {
        self.urlSessionDataTask(urlRequest: urlRequest, completion: completion)
    }
    
    private func urlSessionDataTask(urlRequest: URLRequest,
                                    completion: @escaping ((Result<AnyResponse, NetworkError>) -> Void) = { _ in }) {
        
        urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.logger?.log(response as? HTTPURLResponse, data: data, error: error)
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            
            guard error == nil, let data else {
                DispatchQueue.main.async {
                    completion(.failure(.error(statusCode: statusCode)))
                }
                return
            }
            
            guard (200..<300).contains(statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.error(data, statusCode: statusCode)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(.init(data: data, response: response)))
            }
        }.resume()
    }
    
    public func urlRequest(from endpoint: Endpoint) -> URLRequest? {
        return try? URLRequest(from: endpoint)
    }
    
    /// Sets logging level
    ///
    /// - Parameters: level: Logging level
    public func setLogginig(level: Logger.Level) {
        self.logger = Logger()
        self.logger?.logLevel = level
    }
}
