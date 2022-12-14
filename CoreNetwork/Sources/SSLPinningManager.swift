//
//  SSLPinningManager.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 08.12.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

final public class SSLPinningManager {
    
    static public func validate(publicKeys: String...,
                                domain: String?,
                                challenge: URLAuthenticationChallenge,
                                completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
         
         guard let serverTrust = challenge.protectionSpace.serverTrust else {
             return completionHandler(.cancelAuthenticationChallenge, nil) }
         
         if let domain = domain {
             let policies = NSMutableArray()
             policies.add(SecPolicyCreateSSL(true, domain as CFString))
             SecTrustSetPolicies(serverTrust, policies)
         }

         // Check if the trust is valid
         guard SecTrustEvaluateWithError(serverTrust, nil) else {
             return completionHandler(.cancelAuthenticationChallenge, nil)
         }
         
         // For each certificate in the valid trust:
         for index in 0..<SecTrustGetCertificateCount(serverTrust) {
             
             guard let certificate = SecTrustGetCertificateAtIndex(serverTrust, index),
                   let publicKey = SecCertificateCopyKey(certificate),
                 let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) else {
                 return completionHandler(.cancelAuthenticationChallenge, nil)
             }
             
             let serverPublicKey = (publicKeyData as Data).sha256Base64Encoded()
             if publicKeys.contains(serverPublicKey) {
                 print("SSL Pin found for \(domain ?? "")")
                 return completionHandler(.useCredential, URLCredential(trust: serverTrust))
             }
         }
         completionHandler(.cancelAuthenticationChallenge, nil)
     }
    
}
