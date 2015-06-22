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
import ReactiveCocoa
import Dodo
import AudioToolbox

class MainView: UIView {
    
    override func drawRect(rect: CGRect) {
        StyleKit.drawMain(frame: self.bounds)
    }
    
}

class MainViewController: SlidePageViewController {
    
    let sourceSignal: SignalProducer<[String:TicketViewModel], NoError>
    
    private let navigationOffset = CGFloat(50)
    private var setupDone = false
    
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var ticketsButton: UIButton!
    
    init(slider: SliderController) {
        // Reactive signal
        sourceSignal = slider.ticketsCtrl.items.producer
        super.init(slider: slider, nibName: "MainViewController", bundle: nil)
        
        sourceSignal.start(next: { data in
            self.slider.nextPage()
        })
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        // Setup message bar
        view.dodo.topLayoutGuide = self.topLayoutGuide
        view.dodo.bottomLayoutGuide = self.bottomLayoutGuide
        
        observeSignals()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !setupDone {
            aboutButton.center.y = aboutButton.center.y + navigationOffset
            ticketsButton.center.y = ticketsButton.center.y + navigationOffset
        }
    }
    
    
    // MARK: Features
    
    func observeSignals() {
        slider.ticketsCtrl.signalTicketNumberCall.observe { ticket in
            let alertController = UIAlertController(title: "Senha \(ticket.current)", message: "\nChegou a sua vez!\n\n Desloque-se ao:\n Serviço - \(ticket.service)\n Balcão - \(ticket.desk)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            SoundPlayer().playSound("TicketCall.wav")
            self.showViewController(alertController, sender: nil)
        }
        
        slider.ticketsCtrl.signalError.observe { messageError in
            self.view.dodo.style.leftButton.icon = .Close
            self.view.dodo.style.leftButton.onTap = {
                self.view.dodo.hide()
            }
            self.view.dodo.error(messageError)
        }
    }
    
    func qrCodeResult(reader: QRCodeReaderViewController, data: String) {
        println(data)
        
        let stringToJsonData: String -> NSData? = {
            $0.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
        
        let dataToJsonObject: NSData -> AnyObject? = {
            var err: NSError?
            return NSJSONSerialization.JSONObjectWithData($0, options: .MutableLeaves, error: &err)
        }
        
        reader.dismissViewControllerAnimated(true, completion: { () -> Void in
            // Confirmation
            if let json = data >>- stringToJsonData >>- dataToJsonObject >>- { $0 as? NSDictionary } {
                println(json)
                self.showTicketDialog(json)
            }
        })
    }
    
    func showTicketDialog(ticketDemand: NSDictionary) {
        let service = ticketDemand["service"] as? String ?? ""
        let terminalId = ticketDemand["terminalId"] as? String ?? ""
        
        if service.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
            return
        }
        
        let alertController = UIAlertController(title: "Senha", message: "Deseja tirar senha para o serviço \"\(service)\"?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // Send request
            let ticketRequirements = TicketRequirements(service: service, terminalId: terminalId, device: self.slider.ticketsCtrl.deviceToken)
            self.slider.ticketsCtrl.remote.requestTicket(ticketRequirements)
        }
        alertController.addAction(okAction)
        
        self.showViewController(alertController, sender: nil)
    }
    
    
    // MARK: Actions
    
    func didTouchQRCode(sender: AnyObject?) {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            // Simulator: test
            showTicketDialog(["service":"A"])
            #else
            let reader = QRCodeReaderViewController()
            reader.resultCallback = qrCodeResult
            reader.cancelCallback = {
            $0.dismissViewControllerAnimated(true, completion: nil)
            }
            self.showViewController(reader, sender: nil)
        #endif
    }
    
    func didTouchAbout(sender: AnyObject?) {
        slider.prevPage()
    }
    
    func didTouchTickets(sender: AnyObject?) {
        slider.nextPage()
    }
    
    
    // MARK: Slider Page
    
    override func pageDidAppear() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        setupDone = true
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

}
