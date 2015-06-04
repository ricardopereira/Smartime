//
//  AppDelegate.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import QRCodeReader

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = app()
        return true
    }
    
    func app() -> UIViewController {

        let storyboard = UIStoryboard(name: "Slider", bundle: nil)
        
        // Create the slide pages
        let slideVC = storyboard.instantiateInitialViewController() as! SlideViewController
        
        let statusVC = StatusViewController()
        
        let mainVC = MainViewController()
        mainVC.view.backgroundColor = UIColor(red: 80.0/255.0, green: 168.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        
        let ticketsVC = TicketsViewController()
        
        // Attach the pages to the Slide manager
        slideVC.addViewController(statusVC)
        slideVC.addViewController(mainVC)
        slideVC.addViewController(ticketsVC)
        
        return slideVC
    }

}
