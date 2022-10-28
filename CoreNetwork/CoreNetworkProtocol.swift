//
//  CoreNetworkProtocol.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 27.10.22.
//

import Foundation

public protocol CoreNetworkProtocol: AnyObject {
    var baseURL: String { get }
    var headers: [String : String] { get }
    
}
