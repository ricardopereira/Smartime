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
    @IBOutlet weak var deskLabel: UILabel!
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
        
        selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindViewModel(viewModel: AnyObject) {
        if let ticketViewModel = viewModel as? TicketViewModel {
            serviceLetter.rac_text <~ ticketViewModel.service
            deskLabel.rac_text <~ ticketViewModel.desk.producer |> map({ $0.isEmpty ? "" : "Balcão \($0)" })
            currentText.rac_text <~ ticketViewModel.current.producer |> map({ String(format: "%03d", $0) })
            numberText.rac_text <~ ticketViewModel.number.producer |> map({ String(format: "%03d", $0) })
            
            ticketViewModel.calling.producer.start(next: { sink in
                if ticketViewModel.calling.value {
                    // Cell bouncing when it's your turn
                    UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut | .Autoreverse | .Repeat | .AllowUserInteraction, animations: {
                            self.container.center = CGPointMake(self.container.center.x, self.container.center.y+8)
                    }, completion: { finished in
                        println("Animation finished")
                    })
                }
                else {
                    self.container.layer.removeAllAnimations()
                }
            })
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        container.transform = CGAffineTransformMakeScale(1, 1)
        
        UIView.animateWithDuration(0.07, animations: {
            self.container.transform = CGAffineTransformMakeScale(0.98, 0.98)
        }) { bool in
            UIView.animateWithDuration(0.07, animations: {
                self.container.transform = CGAffineTransformMakeScale(1, 1)
            })
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)

    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
    }
    
}
