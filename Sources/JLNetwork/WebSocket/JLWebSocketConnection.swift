//
//  JLWebSocketConnection.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Combine
import Alamofire

public enum JLWebSocketError: Error {

    case closed(URLSessionWebSocketTask.CloseCode, Data?)
}

public protocol JLWebSocketProtocol: AnyObject, Publisher where Output == JLWebSocketMessage,
                                                              Failure == JLNetworkError {

    func connect()
    func disconnect()
    func send(text: String)
}

public final class JLWebSocketConnection: NSObject {

    // MARK: Properties
    private var sessioConfiguration: URLSessionConfiguration
    private var uRLRequestConvertible: URLRequestConvertible
    private lazy var session: URLSession = {
        URLSession(configuration: sessioConfiguration, delegate: self, delegateQueue: nil)
    }()
    private var webSocketTask: URLSessionWebSocketTask?

    private var maximumNumberReconnectAttempts: Int
    private var numberReconnectAttempts: Int = .zero
    private let subject = PassthroughSubject<Output, Failure>()

    // MARK: Initializers
    public init(with configuration: URLSessionConfiguration,
                uRLRequestConvertible: URLRequestConvertible,
                reconnectAttempts: Int) {

        self.uRLRequestConvertible = uRLRequestConvertible
        self.maximumNumberReconnectAttempts = reconnectAttempts
        self.sessioConfiguration = configuration
    }

    // MARK: Lifecycle
    deinit {

        disconnect()
    }

    // MARK: Methods
    private func createWebSocket() {

        do {
            let request = try uRLRequestConvertible.asURLRequest()
            webSocketTask = session.webSocketTask(with: request)
            
        } catch let error {
            let networkError = self.map(error)
            self.subject.send(completion: .failure(networkError))
        }
    }

    private func handleSocketData(data: Data) {
        
            self.subject.send(.message(data))
    }

    private func listen() {

        webSocketTask?.receive {  [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.handleError(error: error)
                
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handleSocketData(data: data)

                case .string(let string):
                    let data = Data(string.utf8)
                    self.handleSocketData(data: data)

                default:
                    break
                }

                self.listen()
            }
        }
    }

    private func send(message: URLSessionWebSocketTask.Message) {
        
        webSocketTask?.send(message) { [weak self] error in

            guard let self = self else { return }

            if let error = error {

                let networkError = self.map(error)
                self.subject.send(completion: .failure(networkError))
            }
        }
    }

    private func handleError(error: Error) {
        
        if numberReconnectAttempts < maximumNumberReconnectAttempts {
            numberReconnectAttempts += 1
            webSocketTask = nil
            connect()

            return
        }

        let networkError = self.map(error)
        self.subject.send(completion: .failure(networkError))
    }

    private func map(_ error: Error) -> JLNetworkError {
        
        guard let error = error as? URLError else { return .genericError(nil) }

        switch error.code {

        case .notConnectedToInternet:
            return .notConnectedToInternet

        default:
            return .genericError(nil)
        }
    }
}

// MARK: JLWebSocketProtocol
extension JLWebSocketConnection: JLWebSocketProtocol {

    public func receive<S: Subscriber>(subscriber: S)
        where S.Input == JLWebSocketMessage, S.Failure == JLNetworkError {

        subject.receive(subscriber: subscriber)
    }

    public func connect() {
        
        createWebSocket()
        listen()

        webSocketTask?.resume()
    }

    public func disconnect() {

        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    public func send(text: String) {

        send(message: .string(text))
    }
}

// MARK: URLSessionWebSocketDelegate
extension JLWebSocketConnection: URLSessionWebSocketDelegate {

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {

        numberReconnectAttempts = .zero
        subject.send(.open)
    }

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {

        switch closeCode {

        case .normalClosure, .goingAway:
            subject.send(completion: .finished)

        default:
            handleError(error: JLWebSocketError.closed(closeCode, reason))
        }
    }
}
