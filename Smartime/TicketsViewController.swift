//
//  TicketsViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class TicketsViewController: PageViewController {
    
    let tableView = UITableView()
    let ticketCellIdentifier = "TicketCell"
    let items = ["A", "B" , "C"]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsVerticalScrollIndicator = false
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
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Height of cell
        return 150
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Select row
        items.map({ $0 + " - Done" }).flatMap({ value -> Array<String> in println(value); return items })
        
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