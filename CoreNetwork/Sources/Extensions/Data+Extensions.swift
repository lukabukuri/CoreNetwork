//
//  Data+Extensions.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 17.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    
    func sha256Base64Encoded() -> String {
        
        let rsa2048Asn1Header: [UInt8] = [
            0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
        ]
        
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(self)
        
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = keyWithHeader.withUnsafeBytes {
            CC_SHA256($0.baseAddress!, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
        
    }

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
