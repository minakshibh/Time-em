//
//  UserGraphViewController.swift
//  Time-em
//
//  Created by Br@R on 07/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class UserGraphViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var scrollView: UIScrollView!
    var dateArray : NSArray!
    
    
    override func viewDidLoad() {
        //print("Second VC will appear")
        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        print("\(dateArray.objectAtIndex((sender?.view?.tag)!))")
        let alert = UIAlertController(title: "Alert", message: "\(dateArray.objectAtIndex((sender?.view?.tag)!))", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { action in
            switch action.style{
            case .Default:
                print("OK")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Second VC will appear")
        self.graphDataLoading()
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("graphDataLoading"), userInfo: nil, repeats: false)
        super.viewDidAppear(animated)
    }
    
    func graphDataLoading(){
        titleLabel.text = "test"
        scrollView = UIScrollView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        scrollView.backgroundColor = UIColor.clearColor()
        
        dateArray = WeekView.showdates()
        var Xaxis: CGFloat = 0
        if (dateArray == nil || dateArray.count == 0) {
            return
        }
        for var i = 0; i < dateArray.count; i++ {
            let DateView = UIView.init(frame: CGRectMake(Xaxis, 0, 40, scrollView.frame.size.height))
            //DateView.backgroundColor = UIColor.grayColor()
            scrollView.addSubview(DateView)
            DateView.tag = i
            Xaxis = Xaxis+40
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            tap.delegate = self
            DateView.addGestureRecognizer(tap)
            
            let diceRoll = Int(arc4random_uniform(24) + 1)
            let barheight: CGFloat = CGFloat(5.83 * Double(diceRoll))
            let barView  = UIView.init(frame: CGRectMake(DateView.frame.size.width/2-5, DateView.frame.size.height-60-barheight, 10, barheight))
            barView.layer.cornerRadius = 5
            barView.backgroundColor = UIColor.orangeColor()
            DateView.addSubview(barView)
            
            let dayName = UILabel.init(frame: CGRectMake(0, DateView.frame.size.height-60, DateView.frame.size.width, 30))
            dayName.text = "\(dateArray.objectAtIndex(i).valueForKey("dayName")!)"
            dayName.textColor = UIColor.whiteColor()
            dayName.textAlignment = .Center
            
            dayName.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
            DateView.addSubview(dayName)
            
            let DateLabel = UILabel.init(frame: CGRectMake(0, DateView.frame.size.height-30, DateView.frame.size.width, 30))
            DateLabel.text = "\(dateArray.objectAtIndex(i).valueForKey("dayNumber")!)"
            DateLabel.textAlignment = .Center
            DateLabel.textColor = UIColor.whiteColor()
            DateLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
            DateView.addSubview(DateLabel)
            
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(Xaxis,150)
        self.view.addSubview(scrollView)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.removeFromSuperview()
        print("Second VC will disappear")
    }
    
}
