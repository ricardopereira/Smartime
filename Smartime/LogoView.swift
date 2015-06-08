//
//  LogoView.swift
//  Smartime
//
//  Created by Ricardo Pereira on 08/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class LogoView: UIView {
    
    override func drawRect(rect: CGRect) {
        StyleKit.drawSoftLogo(frame: self.bounds)
    }
    
}
