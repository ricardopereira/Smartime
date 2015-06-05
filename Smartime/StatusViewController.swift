//
//  StatusViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import FLXView

class StatusViewController: SlidePageViewController {
    
    override func loadView() {
        let flexView = FLXView()
        flexView.childAlignment = .Stretch
        flexView.direction = .Column
        flexView.padding = FLXPadding(top: 8, left: 0, bottom: 8, right: 0)
        
        let header = FLXView()
        header.childAlignment = .Center
        header.direction = .Row
        header.flx_margins = FLXMargins(top: 0, left: 8, bottom: 0, right: 8)
        flexView.addSubview(header)
        
        let title = Label(text: "Smartime", align: .Center, fontSize: 24)
        title.flx_flex = 1
        title.flx_margins = FLXMargins(top: 8, left: 8, bottom: 8, right: 8)
        header.addSubview(title)
        
        let subtitle = Label(text: "Já conquistou X minutos", align: .Center)
        subtitle.flx_margins = FLXMargins(top: 8, left: 8, bottom: 8, right: 8)
        flexView.addSubview(subtitle)
        
        // Buttons
        let share = Button(label: "Share")
        share.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(share)
        
        //flexView.sizeThatFits
        flexView.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        
        view = flexView
    }
    
}


// MARK: - Support Code -

class Button: UIButton {
    convenience init(label: String) {
        self.init()
        
        setTitle(label, forState: .Normal)
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
    }
}

class Label: UILabel {
    convenience init(text string: String, align: NSTextAlignment = .Center, fontSize: CGFloat = 20) {
        self.init()
        
        font = UIFont(name: "Avenir Next", size: fontSize)
        numberOfLines = 0
        text = string
        textAlignment = align
    }
}