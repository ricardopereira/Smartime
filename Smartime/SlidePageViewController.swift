//
//  SlidePageViewController.swift
//  Smartime
//
//  Created by Yari D'areglia on 17/09/14.
//  Copyright (c) 2014 Yari D'areglia. All rights reserved.
//

import UIKit

class SlidePageViewController: UIViewController, SlidePage {
    
    let slider: SliderController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.masksToBounds = true
    }
    
    convenience init(slider: SliderController) {
        self.init(slider: slider, nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(slider: SliderController, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.slider = slider
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    // MARK: SlidePage Protocol
    
    func pageDidScroll(position: CGFloat, offset: CGFloat) {

    }
    
    func pageDidAppear() {

    }

}