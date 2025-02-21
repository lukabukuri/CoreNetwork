//
//  NetworkTransactionDelegate.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 21.02.25.
//

import Foundation

public protocol NetworkTransactionDelegate: AnyObject {
    func didReceiveResponse(request: URLRequest?, data: Data, response: HTTPURLResponse?)
    func didFailWithError(request: URLRequest?, error: Error?)
    func didCreateRequest(request: URLRequest?)
}

public extension NetworkTransactionDelegate {
    func didCreateRequest(request: URLRequest?) { }
}
