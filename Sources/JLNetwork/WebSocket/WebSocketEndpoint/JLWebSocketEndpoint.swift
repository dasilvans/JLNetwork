//
//  File.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Alamofire

public protocol JLWebSocketEndpoint: URLRequestConvertible {

    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
}

extension JLWebSocketEndpoint {

    var headers: HTTPHeaders? { nil }

    func asURLRequest() throws -> URLRequest {

        let urlRequest = try URLRequest(url: baseURL.appendingPathComponent(path),
                                        method: .get,
                                        headers: headers)

        return urlRequest
    }
}
