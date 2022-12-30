//
//  SSLPinningManager.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 08.12.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

final public class SSLPinningManager {
    
    /// Validates SSL certificate with public keys
    ///
    /// - Parameters:
    ///   - publicKeys: List of public keys for validation
    ///   - domain: Specific domain to validate (i.e. subdomain)
    ///   - challenge: A challenge from a server requiring authentication from the client.
    ///   - completionHandler: A handler that your delegate method must call. This completion handler takes the following parameters::
    ///     - disposition—One of several constants that describes how the challenge should be handled.
    ///     - credential—The credential that should be used for authentication if disposition is `NSURLSessionAuthChallengeUseCredential`, otherwise NULL.
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
