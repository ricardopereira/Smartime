//
//  SlideViewController.swift
//
//  Created by Yari D'areglia on 15/09/14 (wait... why do I wrote code the Day of my Birthday?! C'Mon Yari... )
//  Copyright (c) 2014 Yari D'areglia. All rights reserved.
//

import UIKit

/** 
Walkthrough Page:
The walkthrough page represents any page added to the Walkthrough.
At the moment it's only used to perform custom animations on didScroll.
**/
protocol SlidePage {
    // While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
    // While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
    // The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
    // This value can be used on the previous, current and next page to perform custom animations on page's subviews.
    
    func pageDidScroll(position:CGFloat, offset:CGFloat)   // Called when the main Scrollview...scrolls
}


class SlideViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Public properties -
    
    @IBOutlet var nextButton: UIButton?
    @IBOutlet var prevButton: UIButton?
    
    // The index of the current page (readonly)
    var currentPage: Int {
        get {
            let page = Int((scrollview.contentOffset.x / view.bounds.size.width))
            return page
        }
    }
    
    
    // MARK: - Private properties -
    
    private let scrollview: UIScrollView!
    private var controllers: [UIViewController]!
    private var lastViewConstraint: NSArray?
    
    
    // MARK: - Overrides -
    
    required init(coder aDecoder: NSCoder) {
        // Setup the scrollview
        scrollview = UIScrollView()
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.pagingEnabled = true
        
        // Controllers as empty array
        controllers = Array()
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        scrollview = UIScrollView()
        controllers = Array()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize UIScrollView
        
        scrollview.delegate = self
        scrollview.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.insertSubview(scrollview, atIndex: 0) //scrollview is inserted as first view of the hierarchy
        
        // Set scrollview related constraints
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scrollview]-0-|", options:nil, metrics: nil, views: ["scrollview":scrollview]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollview]-0-|", options:nil, metrics: nil, views: ["scrollview":scrollview]))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: Forced next page
        nextPage()
    }
    
    
    // MARK: - Internal methods -
    
    @IBAction func nextPage() {
        if (currentPage + 1) < controllers.count {
            var frame = scrollview.frame
            frame.origin.x = CGFloat(currentPage + 1) * frame.size.width
            scrollview.scrollRectToVisible(frame, animated: true)
        }
    }
    
    @IBAction func prevPage() {
        if currentPage > 0 {
            var frame = scrollview.frame
            frame.origin.x = CGFloat(currentPage - 1) * frame.size.width
            scrollview.scrollRectToVisible(frame, animated: true)
        }
    }
    
    /**
    addViewController
    Add a new page to the walkthrough. 
    To have information about the current position of the page in the walkthrough add a UIVIewController which implements BWWalkthroughPage    
    */
    func addViewController(vc: UIViewController) {
        
        controllers.append(vc)
        
        // Setup the viewController view
        
        vc.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollview.addSubview(vc.view)
        
        // Constraints
        
        let metricDict = ["w":vc.view.bounds.size.width, "h":vc.view.bounds.size.height]
        
        // - Generic cnst
        
        vc.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(h)]", options:nil, metrics: metricDict, views: ["view":vc.view]))
        vc.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[view(w)]", options:nil, metrics: metricDict, views: ["view":vc.view]))
        scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]|", options:nil, metrics: nil, views: ["view":vc.view,]))
        
        
        if controllers.count == 1 {
            // cnst for position: 1st element
            scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]", options:nil, metrics: nil, views: ["view":vc.view,]))
        }
        else {
            // cnst for position: other elements
            let previousVC = controllers[controllers.count-2]
            let previousView = previousVC.view;
            
            scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[previousView]-0-[view]", options:nil, metrics: nil, views: ["previousView":previousView,"view":vc.view]))
            
            if let cst = lastViewConstraint{
                scrollview.removeConstraints(cst as [AnyObject])
            }
            lastViewConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[view]-0-|", options:nil, metrics: nil, views: ["view":vc.view])
            scrollview.addConstraints(lastViewConstraint! as [AnyObject])
        }
    }

    /** 
    Update the UI to reflect the current walkthrough situation 
    **/
    
    private func updateUI() {
        
        // Hide/Show navigation buttons

        if currentPage == controllers.count - 1{
            nextButton?.hidden = true
        }else{
            nextButton?.hidden = false
        }
        
        if currentPage == 0{
            prevButton?.hidden = true
        }else{
            prevButton?.hidden = false
        }
    }
    
    // MARK: - Scrollview Delegate -
    
    func scrollViewDidScroll(sv: UIScrollView) {
        
        for var i=0; i < controllers.count; i++ {
            
            if let vc = controllers[i] as? SlidePage {
            
                let mx = ((scrollview.contentOffset.x + view.bounds.size.width) - (view.bounds.size.width * CGFloat(i))) / view.bounds.size.width
                
                // While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
                // While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
                // The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
                // This value can be used on the previous, current and next page to perform custom animations on page's subviews.
                
                // print the mx value to get more info.
                // println("\(i):\(mx)")
                
                // We animate only the previous, current and next page
                if (mx < 2 && mx > -2.0) {
                    vc.pageDidScroll(scrollview.contentOffset.x, offset: mx)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateUI()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        updateUI()
    }
    
    
    /* WIP */
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("CHANGE")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("SIZE")
    }
}