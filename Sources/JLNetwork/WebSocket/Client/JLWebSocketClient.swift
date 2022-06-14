//
//  JLWebSocketClient.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Combine
import Alamofire

public protocol JLRequestWebSocketClient {

    func request(_ webSocketEndPoint: JLWebSocketEndpoint) -> JLWebSocketConnection
}

public final class JLWebSocketClient {

    // MARK: Properties
    private enum Constants {

        static let maximumNumberReconnectAttempts: Int = 2
    }

    private let configuration: URLSessionConfiguration

    // MARK: Initializers
    public init(configuration: URLSessionConfiguration) {

        self.configuration = configuration
    }
}

// MARK: JLRequestWebSocketClient
extension JLWebSocketClient: JLRequestWebSocketClient {

    public func request(_ webSocketEndPoint: JLWebSocketEndpoint) -> JLWebSocketConnection {

        return JLWebSocketConnection(with: configuration,
                                   uRLRequestConvertible: webSocketEndPoint,
                                   reconnectAttempts: Constants.maximumNumberReconnectAttempts)
    }
}
