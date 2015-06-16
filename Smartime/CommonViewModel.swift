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
                
                response.append(TicketViewModel(Ticket(["service":"\(self.ticketItems.value.count)", "desk":"Balcão 1", "current":17, "number":23])))
                
                self.ticketItems.put(response)
            default:
                break;
            }
        }
    }
    
}

