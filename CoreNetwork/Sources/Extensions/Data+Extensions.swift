//
//  Data+Extensions.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 17.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

extension Data {

    @discardableResult mutating func append(value: String, encoding: String.Encoding = .utf8) -> Bool {
        if let data = value.data(using: encoding) {
            self.append(data)
            return true
        } else {
            return false
        }
    }

   public var mimeType: String? {
        var byte: UInt8 = 0
        self.copyBytes(to: &byte, count: 1)
        switch byte {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return nil
        }
    }

   public var fileExtension: String? {
        var byte: UInt8 = 0
        self.copyBytes(to: &byte, count: 1)
        switch byte {
        case 0xFF:
            return "jpeg"
        case 0x89:
            return "png"
        case 0x47:
            return "gif"
        case 0x4D, 0x49:
            return "tiff"
        case 0x25:
            return "pdf"
        case 0xD0:
            return "vnd"
        case 0x46:
            return "plain"
        default:
            return nil
        }
    }

}
