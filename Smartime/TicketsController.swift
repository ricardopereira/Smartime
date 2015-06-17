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
    
    let items = MutableProperty<[TicketViewModel]>([TicketViewModel]())
    
    lazy var remote = RemoteStrategy()
    lazy var local = LocalStrategy()
        
    init() {
        remote.socket.on(.TicketCall) {
            switch $0 {
            case .JSON(let json):
                println("Ticket call \(json)")
            default:
                break;
            }
        }
        
        remote.socket.on(.RequestAccepted) {
            switch $0 {
            case .JSON(let json):
                var response = self.items.value
                
                let ticket = Ticket(dict: json)
                response.append(TicketViewModel(ticket))
                
                self.items.put(response)
            default:
                break
            }
        }
    }
    
}

