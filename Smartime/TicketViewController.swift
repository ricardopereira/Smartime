//
//  TicketViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 17/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TicketViewController: UIViewController, ReactiveView {
    
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var deskLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("didTouchClose:"))
        insertBlurView(view, .Dark).addGestureRecognizer(gestureRecognizer)
    }
    
    func bindViewModel(viewModel: AnyObject) {
        if let ticketViewModel = viewModel as? TicketViewModel {
            serviceLabel.rac_text <~ ticketViewModel.service
            deskLabel.rac_text <~ ticketViewModel.desk
            currentLabel.rac_text <~ ticketViewModel.current.producer |> map({ "\($0)" })
            numberLabel.rac_text <~ ticketViewModel.number.producer |> map({ "\($0)" })
        }
    }
    
    func didTouchClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
