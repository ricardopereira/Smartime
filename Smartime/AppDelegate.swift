//
//  AppDelegate.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import FLXView
import ReactiveCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum Events: String, Printable {
        
        case ChatMessage = "chat message"
        case GetImage = "getimage"
        case Image = "image"
        case Login = "login"
        
        var description: String {
            return self.rawValue
        }
        
    }
    
    class Person: SocketIOObject {
        
        let name: String
        
        init(name: String) {
            self.name = name
        }
        
        convenience required init(dict: NSDictionary) {
            self.init(name: dict["name"] as! String)
        }
        
        var asDictionary: NSDictionary {
            return ["name": name]
        }
        
    }
    
    struct ImageInfo: SocketIOObject {
        
        let buffer: String
        
        init(buffer: String) {
            self.buffer = buffer
        }
        
        init(dict: NSDictionary) {
            self.init(buffer: dict["buffer"] as! String)
        }
        
        var asDictionary: NSDictionary {
            return ["buffer": buffer]
        }
        
    }
    
    var window: UIWindow?
    var socket: SocketIO<Events>!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = start()
        
        
        let reader = QRReaderViewController()
        reader.resultCallback = {
            println($0)
            reader.dismissViewControllerAnimated(true, completion: nil)
        }
        reader.cancelCallback = {
            reader.dismissViewControllerAnimated(true, completion: nil)
        }
        window?.rootViewController?.presentViewController(reader, animated: true, completion: nil)
        
        
        socket = SocketIO(url: "http://localhost:8001/")
        
        socket.on(.ConnectError) {
            switch $0 {
            case .Failure(let error):
                println(error)
            default:
                break
            }
        }.on(.Connected) { (arg: SocketIOArg) -> () in
            println("User event telling that it was connected")
        }
        
        socket.on(.Image, withCallback: { (arg: SocketIOArg) -> () in
            switch arg {
            case .Message(let message):
                println("Finally: \(message)")
            case .JSON(let json):
                let imageInfo = ImageInfo(dict: json)
                
                if let image = imageInfo.buffer >>- Utilities.base64EncodedStringToUIImage {
                    println(image)
                }
            default:
                println("Not supported")
            }
        })
        
        return true
    }
    
    func start() -> UIViewController {
        let flexView = FLXView()
        flexView.backgroundColor = UIColor.blueColor()
        flexView.childAlignment = .Stretch
        flexView.direction = .Column
        flexView.padding = FLXPadding(top: 8, left: 0, bottom: 8, right: 0)
        
        let header = FLXView()
        header.childAlignment = .Center
        header.direction = .Row
        header.flx_margins = FLXMargins(top: 0, left: 8, bottom: 0, right: 8)
        flexView.addSubview(header)
        
        let title = Label(text: "Necropsittacus Borbonicus", align: .Center, fontSize: 24)
        title.flx_flex = 1
        title.flx_margins = FLXMargins(top: 8, left: 8, bottom: 8, right: 8)
        header.addSubview(title)
        
        let subtitle = Label(text: "A pretty but unfortunately extinct bird.", align: .Left)
        subtitle.flx_margins = FLXMargins(top: 8, left: 8, bottom: 8, right: 8)
        flexView.addSubview(subtitle)
        
        flexView.addSubview(Separator())
        
        let tags = Label(text: "Tags:", align: .Left)
        tags.flx_margins = FLXMargins(top: 8, left: 8, bottom: 8, right: 8)
        flexView.addSubview(tags)
        
        let tagList = FLXView(frame: CGRectMake(0, 0, 200, 200))
        tagList.childAlignment = .Start
        tagList.direction = .Row
        tagList.flx_margins = FLXMargins(top: 0, left: 8, bottom: 8, right: 8)
        tagList.wrap = true
        flexView.addSubview(tagList)
        
        for tagName in ["Bird", "Extinct", "Red", "Réunion", "Parrot", "Psittacinae"] {
            let tag = Tag(name: tagName)
            tag.flx_margins = FLXMargins(top: 0, left: 0, bottom: 4, right: 4)
            tagList.addSubview(tag)
        }
        
        flexView.addSubview(Separator())
        
        // Buttons
        let connect = Button(label: "Connect")
        connect.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(connect)
        
        let disconnect = Button(label: "Disconnect")
        disconnect.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(disconnect)
        
        let send = Button(label: "Send")
        send.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(send)
        
        let reconnect = Button(label: "Reconnect")
        reconnect.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(reconnect)
        
        let login = Button(label: "Login")
        login.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(login)
        
        // Base
        let mainVC = UIViewController()
        mainVC.view.backgroundColor = UIColor.greenColor()
        
        // Events
        connect.addTarget(self, action: Selector("didTouchConnect:"), forControlEvents: .TouchUpInside)
        disconnect.addTarget(self, action: Selector("didTouchDisconnect:"), forControlEvents: .TouchUpInside)
        send.addTarget(self, action: Selector("didTouchSend:"), forControlEvents: .TouchUpInside)
        reconnect.addTarget(self, action: Selector("didTouchReconnect:"), forControlEvents: .TouchUpInside)
        login.addTarget(self, action: Selector("didTouchLogin:"), forControlEvents: .TouchUpInside)
        
        // Subview
        //mainVC.view.addSubview(flexView)

        mainVC.view = flexView
        
        // Fullscreen
        /*
        flexView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(item: flexView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainVC.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: flexView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainVC.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: flexView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: mainVC.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: flexView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: mainVC.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        
        mainVC.view.addConstraints(constraints)
        */
        
        return mainVC
    }
    
    func didTouchConnect(sender: AnyObject?) {
        socket.connect()
    }
    
    func didTouchDisconnect(sender: AnyObject?) {
        socket.disconnect()
    }
    
    func didTouchSend(sender: AnyObject?) {
        socket.emit(.GetImage, withMessage: "I'm iOS")
    }
    
    func didTouchReconnect(sender: AnyObject?) {
        socket.reconnect()
    }
    
    func didTouchLogin(sender: AnyObject?) {
        socket.emit(.Login, withObject: Person(name: "John"))
    }
    
    
    // MARK: Support Code
    
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
    
    class Separator: UIView {
        convenience init() {
            self.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            
            backgroundColor = UIColor(white: 0.92, alpha: 1)
        }
    }
    
    class Tag: UILabel {
        static let Padding = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        
        convenience init(name: String) {
            self.init()
            
            font = UIFont(name: "Avenir Next", size: 16)
            layer.backgroundColor = UIColor(hue: 0.3, saturation: 0.5, brightness: 0.8, alpha: 1).CGColor
            layer.borderColor = UIColor(white: 0.92, alpha: 1).CGColor
            layer.borderWidth = 1
            layer.cornerRadius = 4
            text = name
            textColor = UIColor.whiteColor()
        }
        
        override func sizeThatFits(size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size)
            
            result.width += Tag.Padding.left + Tag.Padding.right
            result.height += Tag.Padding.top + Tag.Padding.bottom
            
            return result
        }
        
        override func drawTextInRect(rect: CGRect) {
            super.drawTextInRect(UIEdgeInsetsInsetRect(rect, Tag.Padding))
        }
    }

}
