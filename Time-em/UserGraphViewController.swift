//
//  UserGraphViewController.swift
//  Time-em
//
//  Created by Br@R on 07/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class UserGraphViewController: UIViewController, UIGestureRecognizerDelegate 
{
    
    @IBOutlet var titleLabel: UILabel!
    var userTaskGraphDataArray : NSMutableArray = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var scrollView: UIScrollView!
    var bottomLine: UILabel!
    var currentDateLbl: UILabel!
    var linesBackView : UIView!
    var bgLabel : UILabel!
    var dateArray : NSMutableArray!

    
    override func viewDidLoad() {
        //print("Second VC will appear")
        
    }
    override func viewWillAppear(animated: Bool) {
        self.graphDataLoading()
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
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Second VC will appear")
        self.graphDataLoading()
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("graphDataLoading"), userInfo: nil, repeats: false)
        super.viewDidAppear(animated)
    }
    
    func graphDataLoading(){
        self.removeAllViewsFromSUperView()

        scrollView = UIScrollView.init(frame: CGRectMake(20, 0, self.view.frame.size.width-20, 200))
        scrollView.backgroundColor = UIColor.clearColor()
        self.fetchUserTaskGraphDataFromDatabase()
        if userTaskGraphDataArray.count == 0 { return }
        
        bgLabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        bgLabel.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        self.view.addSubview(bgLabel)

        dateArray = WeekView.showdates(userTaskGraphDataArray .mutableCopy() as! NSMutableArray, graphTypeIsTasks: true)

        if (dateArray == nil || dateArray.count == 0) {
            return
        }
        let timeSpentArray : NSMutableArray = []
        
        for num in 0 ..< dateArray.count
        {
            timeSpentArray.addObject(dateArray[num].valueForKey("timespent")!)
        }

        let intMax = timeSpentArray.valueForKeyPath("@max.self")!
        let maxTimeSpentvalue = CGFloat(intMax as! NSNumber)
        
        var maxHours: CGFloat = CGFloat(maxTimeSpentvalue as NSNumber)
        let partsOfYaxix : CGFloat = 6

        if (maxTimeSpentvalue % partsOfYaxix != 0)
        {
            maxHours = CGFloat( Int(maxTimeSpentvalue/partsOfYaxix) * Int(partsOfYaxix)) + partsOfYaxix
        }
       

        var Xaxis: CGFloat = 10
        var bottomLineY :CGFloat = 100
        let dateViewWidth: CGFloat = scrollView.frame.size.width/7
        let maxHeightGraph: CGFloat = 120.0
        let YaxixRatio : CGFloat = maxHours/partsOfYaxix
        let ratio: CGFloat = maxHeightGraph/partsOfYaxix
        var scrollXaxis: CGFloat = 10
        
        
        
        for i in 0 ..< dateArray.count {
            let DateView = UIView.init(frame: CGRectMake(Xaxis, 0, dateViewWidth, scrollView.frame.size.height))
            //DateView.backgroundColor = UIColor.grayColor()
            scrollView.addSubview(DateView)
            DateView.tag = i
            Xaxis = Xaxis+dateViewWidth
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            tap.delegate = self
            DateView.addGestureRecognizer(tap)
            
            let DateLabel = UILabel.init(frame: CGRectMake(0, 2, DateView.frame.size.width, 30))
            DateLabel.text = "\(dateArray.objectAtIndex(i).valueForKey("dayNumber")!)"
            DateLabel.textAlignment = .Center
            DateLabel.textColor = UIColor.blackColor()
            DateLabel.font = UIFont.systemFontOfSize(14.0)
            
            let currentDate = ((dateArray.objectAtIndex(i).valueForKey("isCurrentDate")!) as? NSNumber)?.boolValue
            
            if currentDate == true {
                let x : CGFloat = DateLabel.frame.origin.x+7;
                let y : CGFloat = DateLabel.frame.origin.y;
                
                
                let DateBgLbl = UILabel.init(frame: CGRectMake(x, y, 25, 25))
                DateBgLbl.center = DateLabel.center
                scrollXaxis = DateView.frame.origin.x
                DateBgLbl.backgroundColor = UIColor(red: 34.0/255, green: 44.0/255, blue: 69.0/255, alpha: 1)
                DateBgLbl.layer.cornerRadius = DateBgLbl.frame.size.width/2
                DateBgLbl.clipsToBounds = true
                DateView.addSubview(DateBgLbl)
                
                DateLabel.textColor = UIColor.whiteColor()
            }
                        
            DateView.addSubview(DateLabel)
            
            let dayName = UILabel.init(frame: CGRectMake(0,28, DateView.frame.size.width, 25))
            dayName.text = "\(dateArray.objectAtIndex(i).valueForKey("dayName")!)"
            dayName.textColor = UIColor.blackColor()
            dayName.textAlignment = .Center
            dayName.font = UIFont.systemFontOfSize(12.0)
            DateView.addSubview(dayName)
            
            //            let maxBarHeight : CGFloat = 24.0
            //            let diceRoll = Int(arc4random_uniform(24) + 1)
            //            let barheight : CGFloat = CGFloat(5 * maxBarHeight)
            
            let hours :CGFloat = CGFloat(((dateArray.objectAtIndex(i).valueForKey("timespent")!) as? NSNumber)!)
            let barheight : CGFloat = CGFloat(hours * (maxHeightGraph/maxHours))
            
            let barView  = UIView.init(frame: CGRectMake(DateView.frame.size.width/2-5, DateView.frame.size.height - barheight, 10, barheight))
//            barView.layer.cornerRadius = 3
            //80 176 202
            let path = UIBezierPath(roundedRect:barView.bounds, byRoundingCorners:[.TopRight, .TopLeft], cornerRadii: CGSizeMake(20, 20))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.CGPath
            barView.layer.mask = maskLayer
            
            
            barView.backgroundColor = UIColor(red: 80.0/255.0, green: 176.0/255.0, blue: 202.0/255.0, alpha: 1.0)
            //            barView.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            
            DateView.addSubview(barView)
            
            bottomLineY = DateView.frame.size.height
            
        }
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(Xaxis,150)
      
        ///// scroll view moves to current date /////
        let toVisible :CGRect = CGRectMake(scrollXaxis, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        scrollView .scrollRectToVisible(toVisible, animated: true)
        
    
        
        //// bottom line of scale showx x-axis ////
        bottomLine = UILabel.init(frame: CGRectMake(scrollView.frame.origin.x, bottomLineY, self.view.frame.size.width - scrollView.frame.origin.x, 1))
        bottomLine.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        //// Current date label in center ////
        currentDateLbl = UILabel.init(frame: CGRectMake(0,50, self.view.frame.size.width, 20))
        currentDateLbl.textColor = UIColor.blackColor()
        currentDateLbl.textAlignment = .Center
        currentDateLbl.font = UIFont.systemFontOfSize(11.0)
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d MMM,yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateStr: String = dateFormatter.stringFromDate(NSDate())
        currentDateLbl.text = "\(dateStr)"
        
        
        //// Measurement divider lines ////
        bottomLineY = bottomLine.frame.origin.y
        var Yaxis : CGFloat = bottomLineY
        
        linesBackView = UIView.init(frame: CGRectMake(0, 0, 25, scrollView.frame.size.height))
        linesBackView.backgroundColor = UIColor.clearColor()
        for k in 0 ... Int(partsOfYaxix) {
            let lineLbl = UILabel.init(frame: CGRectZero)
            let lineNumberLbl = UILabel.init(frame: CGRectZero)
            lineLbl.backgroundColor = UIColor.blackColor()
            
            lineLbl.frame = CGRectMake(0,Yaxis, 10, 0.5)
            lineNumberLbl.frame = CGRectMake(10,Yaxis-5, 20, 10)
            lineNumberLbl .text = "\(k * Int(YaxixRatio))"
            lineNumberLbl.font = UIFont.systemFontOfSize(7.0)
            lineNumberLbl.minimumScaleFactor = 0.2
            lineNumberLbl.adjustsFontSizeToFitWidth = true;

            Yaxis = Yaxis - ratio
            
            linesBackView.addSubview(lineLbl)
            linesBackView.addSubview(lineNumberLbl)
        }
        
        self.view.addSubview(currentDateLbl)
        self.view.addSubview(bottomLine)
        self.view.addSubview(scrollView)
        self.view.addSubview(linesBackView)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
       self.removeAllViewsFromSUperView()

        print("Second VC will disappear")
    }
    func removeAllViewsFromSUperView() {
        if (scrollView != nil){  scrollView.removeFromSuperview() }
        if (bottomLine != nil){  bottomLine.removeFromSuperview() }
        if (currentDateLbl != nil){  currentDateLbl.removeFromSuperview() }
        if (linesBackView != nil){  linesBackView.removeFromSuperview() }
        if (bgLabel != nil){  bgLabel.removeFromSuperview() }
    }
    
    func fetchUserTaskGraphDataFromDatabase() {
        let databaseFetch = databaseFile()
        userTaskGraphDataArray = databaseFetch.getUserTaskGraphData()
        print("\(userTaskGraphDataArray)")
    }
}
