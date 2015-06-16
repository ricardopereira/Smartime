//
//  TicketRequirements.swift
//  Smartime
//
//  Created by Ricardo Pereira on 16/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

struct TicketRequirements {
    
    let service: String
    let terminalId: String
    let device: String
    
}

extension TicketRequirements: SocketIOObject {
    
    init(dict: NSDictionary) {
        service = dict["service"] as? String ?? ""
        terminalId = dict["terminalId"] as? String ?? ""
        device = dict["device"] as? String ?? ""
    }
    
    var asDictionary: NSDictionary {
        return ["service":service, "terminalId":terminalId, "device":device]
    }
    
}