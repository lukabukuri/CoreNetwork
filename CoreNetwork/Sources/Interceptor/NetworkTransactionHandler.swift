//
//  NetworkTransactionHandler.swift
//

import Foundation
import Combine

final public class NetworkTransactionHandler: NetworkTransactionDelegate {
        
    @Published var transactions: [NetworkTransaction] = []
    
    static public let shared = NetworkTransactionHandler()
    
    private init() { }
    
    public func didReceiveResponse(request: URLRequest?, data: Data, response: HTTPURLResponse?) {
        transactions.append(.init(request: request, combinedResponse: .init(data: data, response: response), error: nil))
    }
    
    public func didFailWithError(request: URLRequest?, error: (any Error)?) {
        transactions.append(.init(request: request, combinedResponse: nil, error: error))
    }
    
    public func clearTransactions() {
        transactions.removeAll()
    }
}


struct NetworkTransaction {
    
    let id = UUID()
    let request: URLRequest?
    let combinedResponse: AnyResponse?
    let error: (any Error)?
    
}
