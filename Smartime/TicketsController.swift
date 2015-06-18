//
//  TicketsController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 05/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import ReactiveCocoa

class TicketsController {
    
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    var deviceToken: String = "Simulator"
    #else
    var deviceToken: String = ""
    #endif
    
    let items = MutableProperty<[String:TicketViewModel]>([String:TicketViewModel]())
    
    lazy var remote = RemoteStrategy()
    lazy var local = LocalStrategy()
        
    init() {
        remote.socket.on(.TicketCall) {
            switch $0 {
            case .JSON(let json):
                var ticketsList = self.items.value
                
                let ticketCall = Ticket(dict: json)
                var ticket = TicketViewModel(ticketCall)
                
                // Update
                if let item = ticketsList[ticketCall.service] {
                    item.desk.put(ticket.desk.value)
                    item.current.put(ticket.current.value)
                }
            default:
                break;
            }
        }
        
        remote.socket.on(.RequestAccepted) {
            switch $0 {
            case .JSON(let json):
                var ticketsList = self.items.value
                
                let ticket = Ticket(dict: json)
                // Add
                ticketsList[ticket.service] = TicketViewModel(ticket)
                
                self.items.put(ticketsList)
            default:
                break
            }
        }
    }
    
}
