//
//  JLErrorMapper.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

protocol JLErrorMapper {

    func map(_ error: Error) -> JLNetworkError
}

extension JLErrorMapper {

    func map(_ error: Error) -> JLNetworkError {

        switch error {

        case JLNetworkError.genericError(let data):
            return .genericError(data)

        case JLNetworkError.unauthorized(let data):
            return .unauthorized(data)

        case JLNetworkError.notConnectedToInternet:
            return .notConnectedToInternet

        case JLNetworkError.noDataAvailable:
            return .noDataAvailable

        case JLNetworkError.decodingFailure,
             DecodingError.dataCorrupted:
            return .decodingFailure

        case JLNetworkError.cancelled:
            return .cancelled

        default:
            return .unknown
        }
    }
}
