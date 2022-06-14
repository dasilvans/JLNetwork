//
//  JLNetworkStatusHandler.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Combine

public protocol JLNetworkStatusHandler: AnyObject {

    var reachability: JLReachability { get }

    func startListening()
    func stopListening()
}

extension JLNetworkStatusHandler {

    public var onStatusChange: Published<JLReachability.Status?>.Publisher? { reachability.$status }

    public func startListening() {

        reachability.manager?.startListening { [weak self] status in

            guard let self = self else { return }

            switch status {

            case .reachable:
                self.reachability.status = .reachable

            case .unknown:
                self.reachability.status = .unknown

            case .notReachable:
                self.reachability.status = .notReachable
            }
        }
    }

    public func stopListening() {

        reachability.manager?.stopListening()
    }

    public var isConnected: Bool { reachability.isReachable }
}
