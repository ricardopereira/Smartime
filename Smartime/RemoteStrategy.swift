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
    case RequestTicket = "request"
    case RequestAccepted = "accepted"
    
    var description: String {
        return self.rawValue
    }
}

class RemoteStrategy {
    
    let socket = SocketIO<ServerEvents>(url: "http://localhost:8000", withOptions: SocketIOOptions().namespace("/app")) //smartime.herokuapp.com
    
    init() {
        setup()
    }
    
    private func setup() {
        // SocketIO-Kit
        socket.on(.ConnectError) {
            switch $0 {
            case .Failure(let error):
                println(error)
            default:
                break
            }
        }.on(.Connected) { (arg: SocketIOArg) -> () in
                println("Connected")
        }.on(.Disconnected) {
            switch $0 {
            case .Message(let message):
                println("Disconnected with no error")
            case .Failure(let error):
                println("Disconnected with error: \(error)")
            default:
                break
            }
        }
        
        socket.on(.TicketCall) {
            switch $0 {
            case .Message(let message):
                println("Mensagem recebida: \(message)")
            default:
                break
            }
        }
                
        socket.connect()
    }
    
    func requestTicket(requirements: TicketRequirements) {
        socket.emit(.RequestTicket, withObject: requirements)
    }
    
}