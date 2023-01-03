import UIKit
import CoreNetwork

class MoviesViewController: UIViewController {
    
    let connectivity = CoreNetwork.Connectivity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkNetworkConnection()
    }
    
    func checkNetworkConnection() {
        self.connectivity.didChange = { [weak self] status in
            switch status {
            case .connected:
                self?.presentAlert(message: "Network connection restored")
            case .disconnected:
                self?.presentAlert(message: "Network connection lost")
            }
        }
    }
}
