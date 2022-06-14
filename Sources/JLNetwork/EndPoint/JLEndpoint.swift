//
//  JLEndpoint.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Alamofire

protocol Endpoint: URLRequestConvertible {

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {

    var headers: HTTPHeaders? { nil }
    var parameters: Parameters? { nil }
}

// MARK: URLRequestConvertible
extension Endpoint {

    func asURLRequest() throws -> URLRequest {

        let urlRequest = try URLRequest(url: baseURL.appendingPathComponent(path),
                                        method: method,
                                        headers: headers)

        return try encoding.encode(urlRequest, with: parameters)
    }
}
