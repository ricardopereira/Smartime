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
    
    init(_ json: NSDictionary) {
        service = json["service"] as! String
        desk = json["desk"] as! String
        current = json["current"] as! Int
        number = json["number"] as! Int
    }
    
}