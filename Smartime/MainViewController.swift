//
//  MainViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import QRCodeReader

class MainViewController: SlidePageViewController {
    
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var ticketsButton: UIButton!
    
    override func loadView() {
        super.loadView()
        view.bounds.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeButton.layer.cornerRadius = 4
        qrCodeButton.layer.borderWidth = 1
        qrCodeButton.layer.borderColor = UIColor(rgba: "#3D54DC").CGColor
        
        // Events
        qrCodeButton.addTarget(self, action: Selector("didTouchQRCode:"), forControlEvents: .TouchUpInside)
        aboutButton.addTarget(self, action: Selector("didTouchAbout:"), forControlEvents: .TouchUpInside)
        ticketsButton.addTarget(self, action: Selector("didTouchTickets:"), forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutButton.center.y = aboutButton.center.y + 50
        ticketsButton.center.y = ticketsButton.center.y + 50
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
            yOffset = (oldOffset - offset) * 50
        }
        else if offset < oldOffset && offset > 0 && offset <= 1 {
            // 1<-0
            yOffset = (oldOffset - offset) * 50
        }
        else if offset > oldOffset && offset > 1 && offset <= 2 {
            // 1->2
            yOffset = (offset - oldOffset) * 50
        }
        else if offset < oldOffset && offset > 1 && offset <= 2 {
            // 2->1
            yOffset = (offset - oldOffset) * 50
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
        
        reader.resultCallback = {
            println($0)
            
            if let jsonData = $0.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                var err: NSError?
                
                let parsed: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableLeaves, error: &err)
                
                if let parsedArray = parsed as? NSArray {

                }
                else if let parsedDictionary = parsed as? NSDictionary {

                }
            }
            
            // Test
            var response = self.slider.viewModel.ticketItems.value
            response.append(TicketViewModel(Ticket(["service":"\(self.slider.viewModel.ticketItems.value.count)", "desk":"Balcão 1", "current":17, "number":23])))
            
            self.slider.viewModel.ticketItems.put(response)
            
            reader.dismissViewControllerAnimated(true, completion: nil)
            
            self.slider.nextPage()
        }
        
        reader.cancelCallback = {            
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

}
