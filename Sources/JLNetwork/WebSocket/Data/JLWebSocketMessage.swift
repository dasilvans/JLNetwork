//
//  JLWebSocketMessage.swift
//  
//
//  Created by jdasilva on 14/06/2022.
//

import Foundation

public enum JLWebSocketMessage {

    case open
    case message(Data)
}
