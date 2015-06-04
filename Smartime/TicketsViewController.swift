//
//  TicketsViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

enum AppEvents: String, Printable {
    case TicketCall = "TicketCall"
    
    var description: String {
        return self.rawValue
    }
}

class TicketsViewController: PageViewController {
    
    let tableView = UITableView()
    let ticketCellIdentifier = "TicketCell"
    var items = ["A", "B" , "C"]
    
    let socket = SocketIO<AppEvents>(url: "http://smartime.herokuapp.com")
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsVerticalScrollIndicator = false
        
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
        super.init(coder: aDecoder)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func loadView() {
        tableView.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        view = tableView
    }
    
    override func viewDidLoad() {

    }
    
}

extension TicketsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Refresh data
        if let ticketCell = cell as? TicketViewCell {
            ticketCell.serviceLetter.text = items[indexPath.row]
        }
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(rgba: "#3D54DC")
        }
        else {
            cell.contentView.backgroundColor = UIColor(rgba: "#00B9DC")
        }
        
        if indexPath.row == 3 {
            //1. Setup the CATransform3D structure
            var rotation = CATransform3DMakeRotation(CGFloat((30*M_PI)/180), CGFloat(0.0), CGFloat(0.7), CGFloat(0.4))
            rotation.m34 = 1.0 / -600
            
            //2. Define the initial state (Before the animation)
            cell.layer.transform = rotation
            cell.alpha = 0
            cell.layer.anchorPoint = CGPointMake(0, 0.5)
            
            //3. Define the final state (After the animation) and commit the animation
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.8)
            
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
            UIView.commitAnimations()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Height of cell
        return 150
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Select row
        items.append("D")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //tableView.beginUpdates()
        //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        //tableView.endUpdates()
        
        tableView.reloadData()
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