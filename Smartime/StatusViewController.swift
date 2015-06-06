//
//  StatusViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 04/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class StatusViewController: SlidePageViewController {
    
    override func loadView() {
        super.loadView()
        view.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    
    override func pageDidScroll(position: CGFloat, offset: CGFloat) {
        let newAlpha = CGFloat(1 - (position / view.frame.width))
        //println("Offset:\(offset) NewAlpha:\(newAlpha) Position:\(position) Width:\(view.frame.width)")
        view.alpha = newAlpha;
    }
    
    override func pageDidAppear() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
    }
    
}