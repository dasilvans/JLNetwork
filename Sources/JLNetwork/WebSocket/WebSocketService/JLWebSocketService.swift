//
//  JLWebSocketService.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

protocol JLWebSocketService {

    var client: JLRequestWebSocketClient { get }

    init(client: JLRequestWebSocketClient)
}
