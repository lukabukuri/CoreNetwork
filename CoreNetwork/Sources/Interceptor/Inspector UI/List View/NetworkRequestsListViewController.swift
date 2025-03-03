//
//  NetworkRequestsListViewController.swift
//

import SwiftUI

public final class NetworkRequestsListViewController: UIHostingController<NetworkRequestsListView> {
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder, rootView: NetworkRequestsListView())
        
        setDismissAction()
    }
    
    public init() {
        super.init(rootView: NetworkRequestsListView())
        
        setDismissAction()
    }
    
    func setDismissAction() {
        rootView.dismissAction = {
            self.dismiss(animated: true)
        }
    }
}
