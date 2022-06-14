//
//  JLAPIClient.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Combine
import Alamofire

public protocol RequestClient {

    func request(_ convertible: URLRequestConvertible) -> Future<Data, JLNetworkError>
    func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor?) -> Future<Data, JLNetworkError>
    func cancelRequests(with path: String)
}

public final class APIClient {

    // MARK: Properties
    private let session: Session

    // MARK: Initializers
    public init(configuration: URLSessionConfiguration) {

        let delegate = JLPinningDelegate()
        self.session = Session(configuration: configuration, delegate: delegate)
    }
}

// MARK: RequestClient
extension APIClient: RequestClient {

    public func request(_ convertible: URLRequestConvertible) -> Future<Data, JLNetworkError> {

        return request(convertible, interceptor: nil)
    }

    public func request(_ convertible: URLRequestConvertible,
                        interceptor: RequestInterceptor?) -> Future<Data, JLNetworkError> {

        if let path = convertible.urlRequest?.url?.path {
            cancelRequests(with: path)
        }

        return Future<Data, JLNetworkError> { [weak self] promise in

            guard let self = self else {
                promise(.failure(.genericError(nil)))
                return
            }

            self.session
                .request(convertible, interceptor: interceptor)
                .validate()
                .responseData { response in

                    switch response.result {

                    case let .success(data):
                        promise(.success(data))

                    case let .failure(error):
                        let resolvedError = error.resolve(with: response.data)
                        promise(.failure(resolvedError))
                    }
                }
        }
    }

    public func cancelRequests(with path: String) {

        session.session.getTasksWithCompletionHandler { dataTasks, _, _ in

            dataTasks.forEach {

                guard
                    let originalPath = $0.originalRequest?.url?.path,
                    originalPath.hasSuffix(path)
                    else { return }

                $0.cancel()
            }
        }
    }
}
