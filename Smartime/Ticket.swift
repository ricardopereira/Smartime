//
//  Ticket.swift
//  Smartime
//
//  Created by Ricardo Pereira on 05/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

struct Ticket {
    
    let service: String
    let desk: String
    let current: Int
    let number: Int

}

extension Ticket: SocketIOObject {
    
    init(dict: NSDictionary) {
        service = dict["service"] as! String
        desk = dict["desk"] as! String
        current = dict["current"] as! Int
        number = dict["number"] as! Int
    }
    
    var asDictionary: NSDictionary {
        return ["service":service, "desk":desk, "current":current, "number":number]
    }
    
}