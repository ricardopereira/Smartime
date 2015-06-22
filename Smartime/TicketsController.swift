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
    
    let items = MutableProperty<[String:TicketViewModel]>([String:TicketViewModel]())
    
    // RAC Signals
    private var _signalTicketNumberCall: Signal<Ticket, NoError>!
    private var _signalRemoteError: Signal<SocketIOError, NoError>!
    
    var signalTicketNumberCall: Signal<Ticket, NoError> {
        return _signalTicketNumberCall
    }
    
    var signalRemoteError: Signal<SocketIOError, NoError> {
        return _signalRemoteError
    }
    
    init() {
        _signalTicketNumberCall = Signal() { sink in
            
            self.remote.socket.on(.TicketCall) {
                switch $0 {
                case .JSON(let json):
                    var ticketsList = self.items.value
                    
                    let ticketCall = Ticket(dict: json)
                    var ticket = TicketViewModel(ticketCall)
                    
                    // Update
                    if let item = ticketsList[ticketCall.service] {
                        item.desk.put(ticket.desk.value)
                        item.current.put(ticket.current.value)
                        
                        // Check
                        if ticketCall.current == item.number.value {
                            item.called.put(true)
                            sendNext(sink, ticketCall)
                        }
                    }
                default:
                    break;
                }
            }
            
            return nil
        }
        
        _signalRemoteError = Signal() { sink in
        
            self.remote.socket.on(.ConnectError) {
                switch $0 {
                case .Failure(let error):
                    sendNext(sink, error)
                default:
                    break;
                }
            }.on(.TransportError) {
                switch $0 {
                case .Failure(let error):
                    sendNext(sink, error)
                default:
                    break;
                }
            }
            
            return nil
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
        
        remote.socket.on(.Advertisement) {
            switch $0 {
            case .JSON(let json):
                if let image = json["buffer"] as? String >>- SocketIOUtilities.base64EncodedStringToUIImage {
                    println(image)
                }
            default:
                println("Not supported")
            }
        }
    }
    
}
