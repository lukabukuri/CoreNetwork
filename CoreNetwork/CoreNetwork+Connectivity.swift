//
//  CoreNetwork+Connectivity.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 04.11.22.
//

import Foundation
import SystemConfiguration

public extension CoreNetwork {
    
    class Connectivity {
        
        /// Connectivity status callbacks
        typealias ConnectivityChanged = (Status) -> Void
        
        // MARK: - Public Properties
        
        /// Determines network connectivity status at the moment
        static var isConnectedToNetwork: Bool {
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }) else {
                return false
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
                return false
            }
            
            /* Only Working for WIFI
             let isReachable = flags == .reachable
             let needsConnection = flags == .connectionRequired
             
             return isReachable && !needsConnection
             */
            
            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)
            
            return ret
        }
        
        /// Callback fired when connectivity status changes
        var didChange: ConnectivityChanged?
        
        // MARK: - Private Properties
        
        /// Timer for polling network connectivity
        private var timer: Timer?
        
        /// Time interval for polling in seconds
        private var pollingInterval: TimeInterval
        
        /// Last status determined
        private var lastStatus: Status = .connected
        
        // MARK: - Lifecycle
        
        /// Creates an instance with specified  `pollingInterval`
        ///
        /// - Parameter pollingInterval: TimeInterval in seconds for polling frequency, set to 1 second by default
        init(pollingInterval: TimeInterval = 1) {
            self.pollingInterval = pollingInterval
        }
        
        // MARK: - Public Methods
        
        /// Schedules timer for polling
        func startPolling() {
            self.timer?.invalidate()
            
            self.timer = Timer(timeInterval: self.pollingInterval,
                               repeats: true,
                               block: { [weak self] timer in
                self?.notifyStatus()
            })
            
            if let timer {
                RunLoop.current.add(timer, forMode: .common)
            }
        }
        
        /// Invalidates timer for polling
        func stopPolling() {
            self.timer?.invalidate()
        }
        
        // MARK: - Private Methods
        
        /// Calls relevant callback with current status
        ///
        /// Callbacks are fired only when current connection status is different from `lastStatus` property
        private func notifyStatus() {
            let currentStatus = checkConnection()
            guard currentStatus != self.lastStatus else { return }
            
            self.lastStatus = currentStatus
            
            self.didChange?(currentStatus)
        }
        
        /// Returns current connection status
        private func checkConnection() -> Status {
            return Self.isConnectedToNetwork ? .connected : .disconnected
        }
        
    }
    
}

// MARK: - Network Connectivity Status
public extension CoreNetwork.Connectivity {
    enum Status {
        case connected
        case disconnected
    }
}
