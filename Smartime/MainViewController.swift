//
//  MainViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class MainViewController: SlidePageViewController {
    
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var ticketsButton: UIButton!
    
    override func loadView() {
        super.loadView()
        view.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Events
        qrCodeButton.layer.cornerRadius = 4
        qrCodeButton.layer.borderWidth = 1
        qrCodeButton.layer.borderColor = UIColor(rgba: "#3D54DC").CGColor
        
        qrCodeButton.addTarget(self, action: Selector("didTouchQRCode:"), forControlEvents: .TouchUpInside)
        aboutButton.addTarget(self, action: Selector("didTouchAbout:"), forControlEvents: .TouchUpInside)
        ticketsButton.addTarget(self, action: Selector("didTouchTickets:"), forControlEvents: .TouchUpInside)
    }
    
    override func pageDidAppear() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true);
    }
    
    func didTouchQRCode(sender: AnyObject?) {
        // Test
        var response = slider.viewModel.ticketItems.value
        response.append(TicketViewModel(Ticket(["service":"\(slider.viewModel.ticketItems.value.count)", "desk":"Balcão 1", "current":17, "number":23])))
        
        slider.viewModel.ticketItems.put(response.map { $0 })
        
        slider.nextPage()
    }
    
    func didTouchAbout(sender: AnyObject?) {
        slider.prevPage()
    }
    
    func didTouchTickets(sender: AnyObject?) {
        // Test
        slider.viewModel.ticketItems.value[1].currentAsString = "200"
        slider.nextPage()
    }

}
