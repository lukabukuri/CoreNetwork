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
    
    /// Requests credentials from the delegate in response to a session-level authentication request from the remote server.
    ///
    /// - Parameters:
    ///   - session: The session containing the task that requested authentication
    ///   - challenge: An object that contains the request for authentication
    ///   - completionHandler: A handler that your delegate method must call. This completion handler takes the following parameters::
    ///     - disposition—One of several constants that describes how the challenge should be handled.
    ///     - credential—The credential that should be used for authentication if disposition is `NSURLSessionAuthChallengeUseCredential`, otherwise NULL.
    ///
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
