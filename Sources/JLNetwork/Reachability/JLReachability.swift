//
//  JLReachability.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Combine
import Alamofire

public final class JLReachability {

    public enum Status {

        case reachable
        case notReachable
        case unknown
    }

    // MARK: Properties
    @Published var status: Status?

    let manager: NetworkReachabilityManager?

    var isReachable: Bool { manager?.isReachable ?? false }

    // MARK: Initializers
    public init () {

        manager = NetworkReachabilityManager()
    }
}
