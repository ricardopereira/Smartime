//
//  StatusViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class AboutView: UIView {
    
    override func drawRect(rect: CGRect) {
        StyleKit.drawAbout(frame: self.bounds)
    }
    
}

class StatusViewController: SlidePageViewController {
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var about: UILabel!
    
    override func loadView() {
        super.loadView()
        view.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    
    override func pageDidScroll(position: CGFloat, offset: CGFloat) {
        let newAlpha = CGFloat(1 - (position / view.frame.width))
        //println("Offset:\(offset) NewAlpha:\(newAlpha) Position:\(position) Width:\(view.frame.width)")
        subtitle.alpha = newAlpha;
        status.alpha = newAlpha;
        about.alpha = newAlpha;
    }
    
    override func pageDidAppear() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true);
    }
    
}