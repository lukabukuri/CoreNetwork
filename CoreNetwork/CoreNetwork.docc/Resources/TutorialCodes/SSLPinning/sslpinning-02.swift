import Foundation
import CoreNetwork

final class Network: CoreNetwork {
    
    static let shared = Network()
    
    private let isSLLPinningEnabled = true
    
    /// 🔑 Base64-Encoded SHA256 hash
    private let sslPinningPublicKey = "0ZPwMkc2dODj90CAn82FvocHLIZUeCRPHOYS00/1wpQ="
    
    init(configuration: URLSessionConfiguration = .shared) {
        super.init(configuration: configuration)
        
        delegate.sessionDidReceiveChallengeWithCompletion = { session, challenge, completionHandler in
            
            if self.isSLLPinningEnabled {
                SSLPinningManager.validate(
                    publicKeys: sslPinningPublicKey,
                    challenge: challenge,
                    completionHandler: completionHandler)
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
            
        }
    }
}
