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
        
        let notificationSettings = UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert, categories: nil)
        
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        //println("Accepted: \(notificationSettings)")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var deviceTokenStr = deviceToken.description
        
        var tokenRange = Range<String.Index>(start: deviceTokenStr.startIndex.successor(), end: deviceTokenStr.endIndex.predecessor())
        
        deviceTokenStr = deviceTokenStr.substringWithRange(tokenRange)
        
        tokenRange = Range<String.Index>(start: deviceTokenStr.startIndex, end: deviceTokenStr.endIndex)
        
        let deviceID = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: tokenRange)
        
        println(deviceID)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Failed: \(error)")
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
    }
    
    func app() -> UIViewController {

        let storyboard = UIStoryboard(name: "Slider", bundle: nil)
        
        // Create the slide pages
        let slideVC = storyboard.instantiateInitialViewController() as! SlideViewController
        
        let statusVC = StatusViewController(slider: slideVC, nibName: "StatusViewController")
        let mainVC = MainViewController(slider: slideVC, nibName: "MainViewController")
        let ticketsVC = TicketsViewController(slider: slideVC)
        
        // Attach the pages to the Slide manager
        slideVC.addViewController(statusVC)
        slideVC.addViewController(mainVC)
        slideVC.addViewController(ticketsVC)
        
        return slideVC
    }

}
