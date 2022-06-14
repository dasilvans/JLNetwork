//
//  JLPinningDelegate.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Alamofire
import TrustKit

final class JLPinningDelegate: SessionDelegate {

    override func urlSession(_ session: URLSession,
                             task: URLSessionTask,
                             didReceive challenge: URLAuthenticationChallenge,
                             completionHandler: @escaping (URLSession.AuthChallengeDisposition,
                                                           URLCredential?) -> Void) {

        JLPinning.validate(challenge, completionHandler: completionHandler)
    }
}
