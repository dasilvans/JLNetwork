//
//  JLNetworkError.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Alamofire

public enum JLNetworkError: Error {

    case genericError(Data?)
    case unauthorized(Data?)
    case notConnectedToInternet
    case noDataAvailable
    case decodingFailure
    case cancelled
    case unknown
}

// MARK: Equatable
extension JLNetworkError: Equatable { }
