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
    /// - Throws: An error of type `CoreNetwork.Status`
    /// - Returns: Object of generic type passed as a parameter
    open func request<T>(endpoint: Endpoint,
                         type: T.Type = EmptyData.self)
    async throws -> (T, HTTPURLResponse?) where T : Decodable {
        
        let urlRequest = try URLRequest(from: endpoint)
        logger?.log(urlRequest)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        logger?.log(response as? HTTPURLResponse, data: data, error: nil)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        
        guard (200..<300).contains(statusCode) else { throw CoreNetwork.Status.networkError(statusCode: statusCode) }
        
        guard let data = DTODecoder().decode(type: type, data: data) else { throw CoreNetwork.Status.decodingError}
        
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
    open func request<T>(endpoint: Endpoint,
                         type: T.Type = EmptyData.self,
                         completion: @escaping ((Result<(T, HTTPURLResponse?), Status>) -> Void) = { _ in }) where T : Decodable {
        
        guard let urlRequest = try? URLRequest(from: endpoint) else {
            return completion(.failure(.couldNotMakeURLRequest)) }
        
        logger?.log(urlRequest)
        
        urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.logger?.log(response as? HTTPURLResponse, data: data, error: error)
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard error == nil, let data, (200..<300).contains(statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(statusCode: statusCode)))
                }
                return
            }
             
            DispatchQueue.main.async {
                if let data = DTODecoder().decode(type: type, data: data) {
                    completion(.success((data, response as? HTTPURLResponse)))
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// Sets logging level
    ///
    /// - Parameters: level: Logging level
    public func setLogginig(level: Logger.Level) {
        self.logger = Logger()
        self.logger?.logLevel = level
    }
}
