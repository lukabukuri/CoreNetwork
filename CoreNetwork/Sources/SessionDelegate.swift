//
//  SessionDelegate.swift
//  CoreNetwork
//
//  Created by Luka Bukuri on 14.11.22.
//  Copyright © 2022 JSC TBC Bank. All rights reserved.
//

import Foundation

public class SessionDelegate: NSObject, URLSessionDelegate {

    /// Overrides all behavior for URLSessionDelegate method `urlSession(_:didReceive:completionHandler:)` and requires the caller to call the `completionHandler`.
    open var sessionDidReceiveChallengeWithCompletion: ((URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    
    open func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard sessionDidReceiveChallengeWithCompletion == nil else {
            sessionDidReceiveChallengeWithCompletion?(session, challenge, completionHandler)
            return
        }

        let disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        let credential: URLCredential? = nil

        completionHandler(disposition, credential)
    }
}
