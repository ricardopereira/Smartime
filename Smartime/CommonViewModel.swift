//
//  CommonViewModel.swift
//  Smartime
//
//  Created by Ricardo Pereira on 05/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import ReactiveCocoa
//import SocketIO-Kit

enum AppEvents: String, Printable {
    case TicketCall = "TicketCall"
    
    var description: String {
        return self.rawValue
    }
}

class CommonViewModel {
    
    var deviceToken: String = ""
    let ticketItems = MutableProperty<[TicketViewModel]>([TicketViewModel]())
    
    let socket = SocketIO<AppEvents>(url: "http://smartime.herokuapp.com")
    
    init() {
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
        
        //socket.connect()
    }
    
}

