//
//  CoreNetwork+Connectivity.swift
//  CoreNetwork
//
//  Created by Mishka Chargazia on 04.11.22.
//

import UIKit
import SystemConfiguration

public extension CoreNetwork {
    
    class Connectivity {
        
        /// Connectivity status callback
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
        
        /// Determines whether polling is enabled, set value using `setPolling(enabled: )`
        private(set) var isPollingEnabled = false
        
        /// Determines whether polling has been started or not
        private(set) var pollingStarted = false
        
        // MARK: - Lifecycle
        
        /// Creates an instance with specified  `pollingInterval`
        ///
        /// - Parameter pollingInterval: TimeInterval in seconds for polling frequency, set to 1 second by default
        init(pollingInterval: TimeInterval = 1) {
            self.pollingInterval = pollingInterval
        }
        
        /// Deinit
        deinit {
            self.timer?.invalidate()
            NotificationCenter.default.removeObserver(self)
        }
        
        // MARK: - Public Methods
        
        /// Schedules timer for polling
        func startPolling() {
            guard self.isPollingEnabled else { return }
            
            self.activateTimer()
            
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(resumePolling), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(pausePolling), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
        
        /// Invalidates timer for polling
        func stopPolling() {
            self.pollingStarted = false
            self.timer?.invalidate()
        }
        
        /// Sets polling enabled/disabled
        ///
        ///- Parameter enabled: Determines whether polling should be enabled or disabled
        func setPolling(enabled: Bool) {
            self.isPollingEnabled = enabled
        }
        
        // MARK: - Private Methods
        
        /// Calls relevant callback with current status
        ///
        /// Callback is fired only when current connection status is different from `lastStatus` property
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
        
        /// Resume polling
        @objc private func resumePolling() {
            guard self.isPollingEnabled, !self.pollingStarted else { return }
            
            self.activateTimer()
        }
        
        /// Stop polling
        @objc private func pausePolling() {
            self.pollingStarted = false
            self.timer?.invalidate()
        }
        
        /// Activates timer using given polling interval
        private func activateTimer() {
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
        
    }
    
}

// MARK: - Network Connectivity Status
public extension CoreNetwork.Connectivity {
    enum Status {
        case connected
        case disconnected
    }
}
