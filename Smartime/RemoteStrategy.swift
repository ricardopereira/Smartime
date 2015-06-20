//
//  RemoteStrategy.swift
//  Smartime
//
//  Created by Ricardo Pereira on 15/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

enum ServerEvents: String, Printable {
    case TicketCall = "ticket-call"
    
    var description: String {
        return self.rawValue
    }
}

enum AppEvents: String, Printable {
    case TicketCall = "ticket-call"
    case RequestTicket = "request"
    case RequestAccepted = "accepted"
    
    var description: String {
        return self.rawValue
    }
}

class RemoteStrategy {
    
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    // Simulator
    let socket = SocketIO<AppEvents>(url: "http://localhost:8000", withOptions: SocketIOOptions().namespace("/app"))
    #else
    let socket = SocketIO<AppEvents>(url: "http://smartime.herokuapp.com", withOptions: SocketIOOptions().namespace("/app"))
    #endif
    
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

        socket.connect()
    }
    
    func requestTicket(requirements: TicketRequirements) {
        // FIXME: emit when connection was established successfully
        socket.connect()
        socket.emit(.RequestTicket, withObject: requirements)
    }
    
}