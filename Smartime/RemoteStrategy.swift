//
//  RemoteStrategy.swift
//  Smartime
//
//  Created by Ricardo Pereira on 15/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import Runes
import ReactiveCocoa

enum AppEvents: String, Printable {
    case TicketCall = "ticket-call"
    case RequestTicket = "request"
    case RequestAccepted = "accepted"
    case Advertisement = "ad"
    
    var description: String {
        return self.rawValue
    }
}

class RemoteStrategy {
    
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    // Simulator
    private let socket = SocketIO<AppEvents>(url: "http://localhost:8000", withOptions: SocketIOOptions().namespace("/app"))
    #else
    private let socket = SocketIO<AppEvents>(url: "http://smartime.herokuapp.com", withOptions: SocketIOOptions().namespace("/app"))
    #endif
    
    // ReactiveCocoa Signals
    private var _signalTicketCall: Signal<Ticket, NoError>!
    private var _signalTicketRequestAccepted: Signal<Ticket, NoError>!
    private var _signalNewAdvertisement: Signal<UIImage, NoError>!
    private var _signalRemoteError: Signal<SocketIOError, NoError>!
    
    init() {
        setup()
    }
    
    private func setup() {
        socket.on(.ConnectError) {
            switch $0 {
            case .Failure(let error):
                println(error)
            default:
                break
            }
        }.on(.TransportError) {
            switch $0 {
            case .Failure(let error):
                println("WebSocket error: \(error)")
            default:
                break
            }
        }.on(.Connected) { result in
            println("Connected")
        }.on(.Disconnected) { result in
            switch result {
            case .Message(let reason):
                println("Disconnected: \(reason)")
            default:
                break
            }
        }
        
        setupSignals()

        socket.connect()
    }
    
    
    //MARK: ReactiveCocoa Signals
    
    var signalTicketCall: Signal<Ticket, NoError> {
        return _signalTicketCall
    }
    
    var signalTicketRequestAccepted: Signal<Ticket, NoError> {
        return _signalTicketRequestAccepted
    }
    
    var signalNewAdvertisement: Signal<UIImage, NoError> {
        return _signalNewAdvertisement
    }
    
    var signalRemoteError: Signal<SocketIOError, NoError> {
        return _signalRemoteError
    }
    
    func setupSignals() {
        _signalRemoteError = Signal() { sink in
            self.socket.on(.ConnectError) {
                switch $0 {
                case .Failure(let error):
                    // Emit
                    sendNext(sink, error)
                default:
                    break;
                }
                }.on(.TransportError) {
                    switch $0 {
                    case .Failure(let error):
                        // Emit
                        sendNext(sink, error)
                    default:
                        break;
                    }
            }
            return nil
        }
        
        _signalTicketCall = Signal() { sink in
            self.socket.on(.TicketCall) {
                switch $0 {
                case .JSON(let json):
                    let ticket = Ticket(dict: json)
                    // Emit
                    sendNext(sink, ticket)
                default:
                    break
                }
            }
            return nil
        }
        
        _signalTicketRequestAccepted = Signal() { sink in
            self.socket.on(.RequestAccepted) {
                switch $0 {
                case .JSON(let json):
                    let ticket = Ticket(dict: json)
                    // Emit
                    sendNext(sink, ticket)
                default:
                    break
                }
            }
            return nil
        }
        
        _signalNewAdvertisement = Signal() { sink in
            self.socket.on(.Advertisement) {
                switch $0 {
                case .JSON(let json):
                    if let image = json["buffer"] as? String >>- SocketIOUtilities.base64EncodedStringToUIImage {
                        // Emit
                        sendNext(sink, image)
                    }
                default:
                    println("Not supported")
                }
            }
            return nil
        }
    }
    
    
    // MARK: Features
    
    func requestTicket(requirements: TicketRequirements) {
        // FIXME: emit when connection was established successfully
        socket.connect()
        socket.emit(.RequestTicket, withObject: requirements)
    }
    
}