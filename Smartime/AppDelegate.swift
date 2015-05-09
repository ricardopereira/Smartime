//
//  AppDelegate.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var socket: SocketIO!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = start()
        
        socket = SocketIO(url: "http://localhost:8000/");
        
        socket.on(.ConnectError) { (arg: SocketIOArg) -> (SocketIOResult) in
            switch arg {
            case .Failure(let error):
                println(error)
            default:
                return SocketIOResult.Success(status: 0)
            }
            return SocketIOResult.Success(status: 0)
        }.on(.Connected) { (arg: SocketIOArg) -> (SocketIOResult) in
            // Connected
            // ToDo: Emit "connect" not possible!
            
            //socket.emit("myevent", withMessage: "sdflkaskdçfjwe")
            //socket.off()
            //socket.emit("myevent", withMessage: "aaaa")
            
            return SocketIOResult.Success(status: 0)
        }
        
        socket.on("chat message", withCallback: { (arg: SocketIOArg) -> (SocketIOResult) in
            switch arg {
            case .Message(let message):
                println("Finally: \(message)")
            default:
                println("Not supported")
            }
            return SocketIOResult.Success(status: 0)
        })
        
        return true
    }
    
    func start() -> UIViewController {
        let mainView = UIViewController()
        mainView.view.backgroundColor = UIColor.blueColor()

        let connectButton = UIButton(frame: CGRectMake(20, 40, 70, 30))
        connectButton.setTitle("Connect", forState: .Normal)
        
        let disconnectButton = UIButton(frame: CGRectMake(20, 120, 100, 30))
        disconnectButton.setTitle("Disconnect", forState: .Normal)
        
        let sendButton = UIButton(frame: CGRectMake(20, 80, 70, 30))
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.layer.cornerRadius = 3.5
        sendButton.layer.borderWidth = 1.0
        sendButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        connectButton.addTarget(self, action: Selector("didTouchConnect:"), forControlEvents: .TouchUpInside)
        disconnectButton.addTarget(self, action: Selector("didTouchDisconnect:"), forControlEvents: .TouchUpInside)
        sendButton.addTarget(self, action: Selector("didTouchSend:"), forControlEvents: .TouchUpInside)
        
        mainView.view.addSubview(connectButton)
        mainView.view.addSubview(disconnectButton)
        mainView.view.addSubview(sendButton)
        return mainView
    }
    
    func didTouchConnect(sender: AnyObject?) {
        socket.connect()
    }
    
    func didTouchDisconnect(sender: AnyObject?) {
        
    }
    
    func didTouchSend(sender: AnyObject?) {
        socket.emit("chat message", withMessage: "I'm iOS")
    }
}
