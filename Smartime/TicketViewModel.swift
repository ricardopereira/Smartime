//
//  TicketViewModel.swift
//  Smartime
//
//  Created by Ricardo Pereira on 05/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import ReactiveCocoa

class TicketViewModel: NSObject {
    
    private let ticket: Ticket
    
    internal let service: ConstantProperty<String>
    internal let desk: MutableProperty<String>
    internal let number: ConstantProperty<Int>
    internal let current: MutableProperty<Int>
    internal let calling: MutableProperty<Bool>
    internal var new = true
    
    init(_ ticket: Ticket) {
        self.ticket = ticket
        
        service = ConstantProperty(ticket.service)
        desk = MutableProperty(ticket.desk)
        number = ConstantProperty(ticket.number)
        current = MutableProperty(ticket.current)
        calling = MutableProperty(false)
    }
    
    var called: Bool {
        return ticket.current >= ticket.number
    }
    
}