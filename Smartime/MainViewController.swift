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
    
    override func loadView() {
        super.loadView()
        view.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Events
        qrCodeButton.addTarget(self, action: Selector("didTouchQRCodeButton:"), forControlEvents: .TouchUpInside)
    }
    
    func didTouchQRCodeButton(sender: AnyObject?) {
        // Test
        var response = slider.viewModel.ticketItems.value
        response.append(TicketViewModel(Ticket(["service":"\(slider.viewModel.ticketItems.value.count)", "desk":"Balcão 1", "current":17, "number":23])))
        
        slider.viewModel.ticketItems.put(response.map { $0 })
        
        slider.nextPage()
    }

}
