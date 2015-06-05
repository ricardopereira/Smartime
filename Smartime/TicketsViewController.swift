//
//  TicketsViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import ReactiveCocoa

enum AppEvents: String, Printable {
    case TicketCall = "TicketCall"
    
    var description: String {
        return self.rawValue
    }
}

class TicketsViewController: PageViewController {
    
    let tableView = UITableView()
    let ticketCellIdentifier = "TicketCell"
    var items = []
    
    let socket = SocketIO<AppEvents>(url: "http://smartime.herokuapp.com")
    
    init(slider: SliderController, sourceSignal: SignalProducer<[TicketViewModel], NoError>) {
        // Reactive signal
        super.init(slider: slider, nibName: nil, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsVerticalScrollIndicator = false
        
        // Reactive
        sourceSignal.start(next: { data in
            self.items = data.map { $0 as TicketViewModel }
            self.tableView.reloadData()
            self.scrollToBottom()
        })
        
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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        tableView.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        view = tableView
    }
    
    override func viewDidLoad() {

    }
    
    func scrollToBottom() {
        if items.count > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: items.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
    
}

extension TicketsViewController: UITableViewDelegate {
    
    func animateEntranceCell(cell: UITableViewCell) {
        cell.center.x += self.view.bounds.width
        cell.alpha = 0
        
        UIView.animateWithDuration(1.1, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .CurveEaseIn, animations: {
            cell.center.x -= self.view.bounds.width
            cell.alpha = 1
            }, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Striped
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(rgba: "#3D54DC")
        }
        else {
            cell.contentView.backgroundColor = UIColor(rgba: "#00B9DC")
        }
        
        // Refresh data
        if let ticketCell = cell as? TicketViewCell, let ticketModel = items[indexPath.row] as? TicketViewModel {
            ticketCell.serviceLetter.text = ticketModel.service.value
            
            // Animation
            if ticketModel.new {
                animateEntranceCell(cell)
                ticketModel.new = false
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Height of cell
        return 150
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Select row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension TicketsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Total of rows
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create cell
        let cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(ticketCellIdentifier)
        
        if let cellText = cell as? TicketViewCell {
            return cellText
        }
        else {
            tableView.registerNib(UINib(nibName: "TicketViewCell", bundle: nil), forCellReuseIdentifier: ticketCellIdentifier)
            let cellText = tableView.dequeueReusableCellWithIdentifier(ticketCellIdentifier) as! UITableViewCell
            return cellText
        }
    }
    
}