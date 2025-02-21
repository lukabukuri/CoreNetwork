//
//  NetworkTransactionDelegate.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 21.02.25.
//

import Foundation

protocol NetworkTransactionDelegate: AnyObject {
    func didReceiveResponse(request: URLRequest?, data: Data, response: HTTPURLResponse?)
    func didFailWithError(request: URLRequest?, error: Error?)
    func didCreateRequest(request: URLRequest?)
}

extension NetworkTransactionDelegate {
    func didCreateRequest(request: URLRequest?) { }
}
