//
//  CommonViewModel.swift
//  Smartime
//
//  Created by Ricardo Pereira on 05/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import ReactiveCocoa

class CommonViewModel {
    
    var deviceToken: String = ""
    let ticketItems = MutableProperty<[TicketViewModel]>([TicketViewModel]())
    
    let server = Server()
        
    init() {
        server.socket.on(.RequestTicket) {
            switch $0 {
            case .JSON(let json):
                var response = self.ticketItems.value
                
                let ticket = Ticket(dict: json)
                response.append(TicketViewModel(ticket))
                
                self.ticketItems.put(response)
            default:
                break;
            }
        }
    }
    
}

