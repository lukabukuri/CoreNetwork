//
//  PresentationManager.swift
//

import UIKit

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (event!.type == .motion && event!.subtype == .motionShake) {
            PresentationManager.shared.toggleNetworkRequestsListViewController()
        }
        super.motionEnded(motion, with: event)
    }
}

public final class PresentationManager {
    public static var shared = PresentationManager()
    
    private lazy var rootVC: UIViewController? = {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first
        else { return nil }
        return keyWindow.rootViewController
    }()
    
    private init() {}
    
    public func toggleNetworkRequestsListViewController() {
        if let viewController = rootVC?.presentedViewController as? NetworkRequestsListViewController {
            viewController.dismiss(animated: true)
        } else {
            present()
        }
    }
    
    private func present() {
        let viewController = NetworkRequestsListViewController()
        rootVC?.present(viewController, animated: true)
    }
}
