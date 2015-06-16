//
//  TicketsViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TicketsTableView: UITableView {
    
    override func drawRect(rect: CGRect) {
        StyleKit.drawCover(frame: self.bounds)
    }
    
}

class TicketsViewController: SlidePageViewController {
    
    let tableView = TicketsTableView()
    let tableLabel = UILabel()
    let dataSource: TicketsDataSource
    let ticketCellIdentifier = "TicketCell"
    
    let sourceSignal: SignalProducer<[TicketViewModel], NoError>
    
    init(slider: SliderController) {
        // Reactive signal
        sourceSignal = slider.ticketsCtrl.items.producer
        // DataSource
        tableView.registerNib(UINib(nibName: "TicketViewCell", bundle: nil), forCellReuseIdentifier: ticketCellIdentifier)
        dataSource = TicketsDataSource(items: [], cellIdentifier: ticketCellIdentifier)
        // TableViewController
        super.init(slider: slider, nibName: nil, bundle: nil)
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        dataSource.onNewTicket = { cell in
            //Animate entrance cell
            cell.center.x += self.view.bounds.width
            cell.alpha = 0
            
            UIView.animateWithDuration(1.1, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .CurveEaseIn, animations: {
                cell.center.x -= self.view.bounds.width
                cell.alpha = 1
                }, completion: nil)
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsVerticalScrollIndicator = false
        
        // Reactive
        sourceSignal.start(next: { data in
            self.dataSource.items = data.map { $0 as TicketViewModel }
            self.tableLabel.hidden = !self.dataSource.items.isEmpty
            self.tableView.reloadData()
            self.scrollToBottom()
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        tableView.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        view = tableView
        
        // No data
        tableLabel.text = "Ainda não tirou nenhuma senha"
        tableLabel.font = UIFont(name: "Avenir Next", size: 14.0)
        tableLabel.textColor = UIColor.whiteColor()
        tableLabel.alpha = 0.6
        tableLabel.sizeToFit()
        tableLabel.center = CGPointMake(tableView.bounds.width/2, tableView.bounds.height/2)
        view.addSubview(tableLabel)
    }
    
    func scrollToBottom() {
        if dataSource.items.count > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: dataSource.items.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
    
    override func pageDidAppear() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
    }
    
}

class TicketsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var items: [TicketViewModel]
    let cellID: String
    var onNewTicket: Optional<(cell: UITableViewCell) -> ()>
    
    init(items: [TicketViewModel], cellIdentifier: String) {
        self.items = items
        self.cellID = cellIdentifier
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Refresh data
        let ticketModel = items[indexPath.row]
        
        if let ticketCell = cell as? TicketViewCell {
            // Events
            if ticketModel.new, let doNewTicket = onNewTicket {
                doNewTicket(cell: cell)
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
    
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Total of rows
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bindViewModel(item)
        }
        return cell
    }
    
}