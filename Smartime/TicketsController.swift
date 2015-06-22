//
//  TicketsController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 05/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Runes

class TicketsController {
    
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    var deviceToken: String = "Simulator"
    #else
    var deviceToken: String = ""
    #endif
    
    lazy var remote = RemoteStrategy()
    lazy var local = LocalStrategy()
    
    // ReactiveCocoa Signals
    private var _signalTicketNumberCall: Signal<Ticket, NoError>!
    private var _signalError: Signal<String, NoError>!
    
    let items = MutableProperty<[String:TicketViewModel]>([String:TicketViewModel]())
        
    init() {
        // Signals
        _signalTicketNumberCall = Signal() { sink in
            self.remote.signalTicketCall.observe { ticket in
                var ticketsList = self.items.value
                var ticketCall = TicketViewModel(ticket)
                
                // Update
                if let item = ticketsList[ticket.service] {
                    item.desk.put(ticketCall.desk.value)
                    item.current.put(ticketCall.current.value)
                    
                    // Check
                    if ticket.current == item.number.value {
                        item.called.put(true)
                        // Emit
                        sendNext(sink, ticket)
                    }
                }
            }
            return nil
        }
        
        _signalError = Signal() { sink in
            self.remote.signalRemoteError.observe { error in
                // Emit
                sendNext(sink, error.message)
            }
            return nil
        }
        
        remote.signalTicketRequestAccepted.observe { ticket in
            var ticketsList = self.items.value
            // Add
            ticketsList[ticket.service] = TicketViewModel(ticket)
            self.items.put(ticketsList)
        }
    }
    
    
    //MARK: ReactiveCocoa Signals
    
    var signalTicketNumberCall: Signal<Ticket, NoError> {
        return _signalTicketNumberCall
    }
    
    var signalError: Signal<String, NoError> {
        return _signalError
    }

}
