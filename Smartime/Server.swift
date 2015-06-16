//
//  Server.swift
//  Smartime
//
//  Created by Ricardo Pereira on 15/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

enum ServerEvents: String, Printable {
    case TicketCall = "TicketCall"
    case RequestTicket = "request"
    
    var description: String {
        return self.rawValue
    }
}

struct TicketRequirements {
    let service: String
    let terminalId: String
    let device: String
}

extension TicketRequirements: SocketIOObject {
    init(dict: NSDictionary) {
        service = dict["service"] as? String ?? ""
        terminalId = dict["terminalId"] as? String ?? ""
        device = dict["device"] as? String ?? ""
    }
    
    var asDictionary: NSDictionary {
        return ["service":service, "terminalId":terminalId, "device":device]
    }
}

class Server {
    
    let socket = SocketIO<ServerEvents>(url: "http://localhost:8000") //smartime.herokuapp.com
    
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
    }
    
    func requestTicket(requirements: TicketRequirements) {
        socket.connect()
        socket.emit(.RequestTicket, withObject: requirements)
    }
    
}