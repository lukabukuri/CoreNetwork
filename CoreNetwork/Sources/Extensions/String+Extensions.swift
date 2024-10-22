//
//  String+Extensions.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 09.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

extension String {
    
    /// Generate and return unique identifier
    static var uuid: String { get { return CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault)) as String } }
    
}
