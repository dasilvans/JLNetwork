//
//  JLPinning.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import TrustKit

public enum JLPinning {

    static func setup(with keys: [JLPinningKeysImplementable] ) {

        let pinnedDomains = Dictionary(uniqueKeysWithValues:
                                        keys.map { ($0.domain, [kTSKPublicKeyHashes: $0.keys, kTSKIncludeSubdomains: true]) })

        let configuration: [String: Any] = [kTSKPinnedDomains: pinnedDomains]
        TrustKit.initSharedInstance(withConfiguration: configuration)
    }

    public static func validate(_ challenge: URLAuthenticationChallenge,
                                completionHandler: @escaping (URLSession.AuthChallengeDisposition,
                                                              URLCredential?) -> Void) {

        let validator = TrustKit.sharedInstance().pinningValidator

        guard validator.handle(challenge, completionHandler: completionHandler) else {

            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
    }

    public static func isPolicyAllowed(for host: String, whiteListDomains: [String]) -> Bool {

        return whiteListDomains.contains(where: host.contains)
    }
}
