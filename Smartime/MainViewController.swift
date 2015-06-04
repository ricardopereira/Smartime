//
//  MainViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import FLXView

class MainViewController: PageViewController {
    
    var connect: UIButton!
    var disconnect: UIButton!
    var send: UIButton!
    var reconnect: UIButton!
    var login: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Events
        connect.addTarget(self, action: Selector("didTouchConnect:"), forControlEvents: .TouchUpInside)
        disconnect.addTarget(self, action: Selector("didTouchDisconnect:"), forControlEvents: .TouchUpInside)
        send.addTarget(self, action: Selector("didTouchSend:"), forControlEvents: .TouchUpInside)
        reconnect.addTarget(self, action: Selector("didTouchReconnect:"), forControlEvents: .TouchUpInside)
        login.addTarget(self, action: Selector("didTouchLogin:"), forControlEvents: .TouchUpInside)
    }

    override func loadView() {
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
        connect = Button(label: "Connect")
        connect.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(connect)
        
        disconnect = Button(label: "Disconnect")
        disconnect.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(disconnect)
        
        send = Button(label: "Send")
        send.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(send)
        
        reconnect = Button(label: "Reconnect")
        reconnect.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(reconnect)
        
        login = Button(label: "Login")
        login.flx_margins = FLXMargins(top: 8, left: 8, bottom: 4, right: 8)
        flexView.addSubview(login)
        
        //flexView.sizeThatFits
        flexView.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        
        view = flexView
    }
    
    func didTouchConnect(sender: AnyObject?) {

    }
    
    func didTouchDisconnect(sender: AnyObject?) {

    }
    
    func didTouchSend(sender: AnyObject?) {

    }
    
    func didTouchReconnect(sender: AnyObject?) {

    }
    
    func didTouchLogin(sender: AnyObject?) {

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
