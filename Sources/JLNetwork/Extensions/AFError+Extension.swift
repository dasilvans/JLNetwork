//
//  AFError+Extension.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Alamofire

extension AFError {

    func resolve(with data: Data?) -> JLNetworkError {

        switch self {

        case .requestRetryFailed:
            return .unauthorized(nil)

        case .requestAdaptationFailed:
            return .unauthorized(nil)

        case let .responseValidationFailed(reason):
            return resolveResponseValidationFailed(reason: reason, data: data)

        case let .sessionTaskFailed(error):
            return resolveSessionTaskFailed(error)

        default:
            return .genericError(nil)
        }
    }
    
    private func resolveResponseValidationFailed(reason: ResponseValidationFailureReason, data: Data?) -> JLNetworkError {

        switch reason {

        case let .unacceptableStatusCode(code):

            switch code {

            case JLStatusCode.unauthorized.rawValue:
                return .unauthorized(data)

            default:
                return .genericError(data)
            }

        default:
            return .genericError(nil)
        }
    }
    
    private func resolveSessionTaskFailed(_ error: Error) -> JLNetworkError {

        guard let error = error as? URLError else { return .genericError(nil) }

        switch error.code {

        case .notConnectedToInternet:
            return .notConnectedToInternet

        case .cancelled:
            return .cancelled

        default:
            return .genericError(nil)
        }
    }
}
