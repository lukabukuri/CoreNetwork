import Foundation
import CoreNetwork

final class Network: CoreNetwork {
    
    static let shared = Network()
    
    init(configuration: URLSessionConfiguration = .shared) {
        super.init(configuration: configuration)
        
        delegate.sessionDidReceiveChallengeWithCompletion = { session, challenge, completionHandler in
            
            
        }
    }
}
