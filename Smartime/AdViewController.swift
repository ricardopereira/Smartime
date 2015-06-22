//
//  AdViewController.swift
//  Smartime
//
//  Created by Ricardo Pereira on 22/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {

    let ad: UIImage
    
    @IBOutlet weak var adImage: UIImageView!
    
    init(ad: UIImage) {
        self.ad = ad
        super.init(nibName: "AdViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("didTouchClose:"))
        insertBlurView(view, .Dark).addGestureRecognizer(gestureRecognizer)
        
        adImage.image = ad
    }
    
    func didTouchClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
