//
//  TicketContainerView.swift
//  Smartime
//
//  Created by Ricardo Pereira on 07/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class TicketContainerView: UIView {
    
    override func drawRect(rect: CGRect) {
        StyleKit.drawTicket(frame: self.bounds)
    }
    
}