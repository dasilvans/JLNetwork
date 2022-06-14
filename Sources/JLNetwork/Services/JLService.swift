//
//  JLService.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation
import Alamofire

protocol JLService {

    var client: RequestClient { get }
    var decoder: JSONDecoder { get }

    init(client: RequestClient, decoder: JSONDecoder)
}
