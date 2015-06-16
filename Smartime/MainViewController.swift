//
//  MainViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import QRCodeReader
import Runes

class MainView: UIView {
    
    override func drawRect(rect: CGRect) {
        StyleKit.drawMain(frame: self.bounds)
    }
    
}

class MainViewController: SlidePageViewController {
    
    private let navigationOffset = CGFloat(50)
    
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var ticketsButton: UIButton!
    
    override func loadView() {
        super.loadView()
        view.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Events
        qrCodeButton.addTarget(self, action: Selector("didTouchQRCode:"), forControlEvents: .TouchUpInside)
        aboutButton.addTarget(self, action: Selector("didTouchAbout:"), forControlEvents: .TouchUpInside)
        ticketsButton.addTarget(self, action: Selector("didTouchTickets:"), forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutButton.center.y = aboutButton.center.y + navigationOffset
        ticketsButton.center.y = ticketsButton.center.y + navigationOffset
    }
    
    override func pageDidAppear() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true);
    }
    
    var oldOffset = CGFloat(0.0)
    
    override func pageDidScroll(position: CGFloat, offset: CGFloat) {
        let yOffset: CGFloat
        
        //println("Position:\(position) Offset:\(offset) Old:\(oldOffset)")
        
        // 0->1 -50 - Offset:1.0 Position:320.0 - Offset > Old
        // 1<-0 +50 - Offset:0.0 Position:0.0 - Offset < Old
        // 1->2 +50 - Offset:1.99 Position:639.5 - Offset > Old
        // 2->1 -50 - Offset:1.0 Position:320.0 - Offset < Old
        
        if offset > oldOffset && offset > 0 && offset <= 1 {
            // 0->1
            yOffset = (oldOffset - offset) * navigationOffset
        }
        else if offset < oldOffset && offset > 0 && offset <= 1 {
            // 1<-0
            yOffset = (oldOffset - offset) * navigationOffset
        }
        else if offset > oldOffset && offset > 1 && offset <= 2 {
            // 1->2
            yOffset = (offset - oldOffset) * navigationOffset
        }
        else if offset < oldOffset && offset > 1 && offset <= 2 {
            // 2->1
            yOffset = (offset - oldOffset) * navigationOffset
        }
        else {
            yOffset = 0
        }
        
        aboutButton.center.y = aboutButton.center.y + yOffset
        ticketsButton.center.y = ticketsButton.center.y + yOffset
        
        oldOffset = offset
    }
    
    func didTouchQRCode(sender: AnyObject?) {
        
        let reader = QRCodeReaderViewController()
        
        reader.resultCallback = readerResult
        reader.cancelCallback = { reader in
            reader.dismissViewControllerAnimated(true, completion: nil)
        }
        self.showViewController(reader, sender: nil)
    }
    
    func didTouchAbout(sender: AnyObject?) {
        slider.prevPage()
    }
    
    func didTouchTickets(sender: AnyObject?) {
        slider.nextPage()
    }
    
    func readerResult(reader: QRCodeReaderViewController, data: String) {
        println(data)
        reader.dismissViewControllerAnimated(true, completion: nil)
        
        let stringToJsonData: String -> NSData? = {
            $0.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
        
        let dataToJsonObject: NSData -> AnyObject? = {
            var err: NSError?
            return NSJSONSerialization.JSONObjectWithData($0, options: .MutableLeaves, error: &err)
        }
        
        if let json = data >>- stringToJsonData >>- dataToJsonObject >>- { $0 as? NSDictionary } {
            println(json)
            
            let service = json["service"] as? String ?? ""
            let terminalId = json["terminalId"] as? String ?? ""
            
            if service.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
                return
            }
            
            let alertController = UIAlertController(title: "Senha", message: "Deseja tirar senha para o serviço \(service)?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // Send request
                let ticketRequirements = TicketRequirements(service: service, terminalId: terminalId, device: self.slider.viewModel.deviceToken)
                self.slider.viewModel.server.requestTicket(ticketRequirements)
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        //self.slider.nextPage()
    }

}
