//
//  TicketViewCell.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TicketViewCell: UITableViewCell, ReactiveView {

    @IBOutlet weak var serviceLetter: UILabel!
    @IBOutlet weak var currentText: UILabel!
    @IBOutlet weak var numberText: UILabel!
    @IBOutlet weak var container: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup
        container.backgroundColor = UIColor.clearColor()
        container.layer.shadowOpacity = 0.4
        container.layer.shadowRadius = 1.7
        container.layer.shadowColor = UIColor.blackColor().CGColor
        container.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        container.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindViewModel(viewModel: AnyObject) {
        if let ticketViewModel = viewModel as? TicketViewModel {
            serviceLetter.rac_text <~ ticketViewModel.service
            currentText.rac_text <~ ticketViewModel.current.producer |> map({ "\($0)" })
            numberText.rac_text <~ ticketViewModel.number.producer |> map({ "\($0)" })
        }
    }
    
}
