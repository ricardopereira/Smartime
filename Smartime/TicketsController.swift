//
//  TicketsController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 05/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import ReactiveCocoa


func createSignalProducer() -> SignalProducer<String, NoError> {
    var count = 0
    return SignalProducer { sink, disposable in
        println("Creating the timer signal producer")
        
        println("Emitting a next event")
        for _ in 1...3 {
            delay(3) {
                sendNext(sink, "tick #\(count++)")
            }
        }
    }
}

func createSignal() -> Signal<String, NoError> {
    var count = 0
    return Signal { sink in
        for _ in 1...6 {
            delay(3) {
                sendNext(sink, "tick #\(count++)")
            }
        }
        return nil
    }
}

public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


class TicketsController {
    
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    var deviceToken: String = "Simulator"
    #else
    var deviceToken: String = ""
    #endif
    
    let items = MutableProperty<[String:TicketViewModel]>([String:TicketViewModel]())
    
    // Test
    let producer: SignalProducer<String, NoError>
    var singalA: Signal<String, NoError>!
    
    lazy var remote = RemoteStrategy()
    lazy var local = LocalStrategy()
    
    init() {
        producer = createSignalProducer()
        //producer.start(next: { println("First \($0)") })
        //producer.start(next: { println("Second \($0)") })
        
        singalA = Signal() { sink in
            println("First time")
            
            self.remote.socket.on(.TicketCall) {
                switch $0 {
                case .JSON(let json):
                    var ticketsList = self.items.value
                    
                    let ticketCall = Ticket(dict: json)
                    var ticket = TicketViewModel(ticketCall)
                    
                    // Update
                    if let item = ticketsList[ticketCall.service] {
                        // Check
                        if ticketCall.current == item.number.value {
                            println("É a sua vez!")
                            sendNext(sink, "tick")
                        }
                        
                        item.desk.put(ticket.desk.value)
                        item.current.put(ticket.current.value)
                    }
                default:
                    break;
                }
            }
            
            return nil
        }
        singalA.observe(next: { println($0) })
        
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
