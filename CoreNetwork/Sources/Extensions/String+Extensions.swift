//
//  String+Extensions.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 09.11.22.
//

import Foundation

extension String {
    
    /// Modifies URL path component string by prepending slash if needed
    func normalizedURLPath() -> Self {
        return !self.hasPrefix("/") && !isEmpty ? "/".appending(self) : self
    }
    
}
