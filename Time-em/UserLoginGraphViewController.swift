//
//  UserLoginGraphViewController.swift
//  Time-em
//
//  Created by Br@R on 07/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class UserLoginGraphViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    var userSignedGraphDataArray : NSMutableArray = []

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var scrollView: UIScrollView!
    var bottomLine: UILabel!
    var dateArray : NSArray!
    var currentDateLbl: UILabel!
    var linesBackView : UIView!
    var shiftsLblBackView : UIView!
    var bgLabel : UILabel!

    
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
//        self.prese ntViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Second VC will appear")
        self.graphDataLoading()
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("graphDataLoading"), userInfo: nil, repeats: false)
        super.viewDidAppear(animated)
    }
    
    func graphDataLoading(){
        
        scrollView = UIScrollView.init(frame: CGRectMake(20, 0, self.view.frame.size.width-20, 200))
        scrollView.backgroundColor = UIColor.clearColor()
        
        self.fetchUserSignedGraphDataFromDatabase()
        if userSignedGraphDataArray.count == 0 { return }

//        dateArray = WeekView.showdates(userSignedGraphDataArray .mutableCopy() as! NSMutableArray) 
        dateArray = WeekView.showdates(userSignedGraphDataArray .mutableCopy() as! NSMutableArray, graphTypeIsTasks: false)
        if (dateArray == nil || dateArray.count == 0) {
            return
        }
        
        let signedinArray : NSMutableArray = []
        let signedoutArray : NSMutableArray = []

        for num in 0 ..< dateArray.count
        {
            signedinArray.addObject(dateArray[num].valueForKey("signedin")!)
            signedoutArray.addObject(dateArray[num].valueForKey("signedout")!)
        }
        
        let signedinIntMax = signedinArray.valueForKeyPath("@max.self")!
        let signedoutIntMax = signedoutArray.valueForKeyPath("@max.self")!
        var maxTimeSpentvalue : CGFloat = 0
        
        
        if CGFloat(signedinIntMax as! NSNumber) > CGFloat(signedoutIntMax as! NSNumber) {
            let intMax = signedinArray.valueForKeyPath("@max.self")!
            maxTimeSpentvalue = CGFloat(intMax as! NSNumber)

        }
        else{
            let intMax = signedoutArray.valueForKeyPath("@max.self")!
            maxTimeSpentvalue = CGFloat(intMax as! NSNumber)

        }
        
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
//        let signInHeightGraph: CGFloat = 100.0
//        let signOutHeightGraph: CGFloat = 80.0
        
        for i in 0 ..< dateArray.count {
            let DateView = UIView.init(frame: CGRectMake(Xaxis, 0, dateViewWidth, scrollView.frame.size.height))
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
            
            let signInHours :CGFloat = CGFloat(((dateArray.objectAtIndex(i).valueForKey("signedin")!) as? NSNumber)!)
            let signInHeightGraph : CGFloat = CGFloat(signInHours * (maxHeightGraph/maxHours))
            
            let signInBarView  = UIView.init(frame: CGRectMake(DateView.frame.size.width/2-5, DateView.frame.size.height-signInHeightGraph, 10, signInHeightGraph))
//            signInBarView.layer.cornerRadius = 3
            let path = UIBezierPath(roundedRect:signInBarView.bounds, byRoundingCorners:[.TopRight, .TopLeft], cornerRadii: CGSizeMake(20, 20))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.CGPath
            signInBarView.layer.mask = maskLayer
            //80 176 202
            signInBarView.backgroundColor = UIColor(red: 80.0/255.0, green: 176.0/255.0, blue: 202.0/255.0, alpha: 1.0)
            DateView.addSubview(signInBarView)
            
            let signOutHours :CGFloat = CGFloat(((dateArray.objectAtIndex(i).valueForKey("signedout")!) as? NSNumber)!)
            let signOutHeightGraph : CGFloat = CGFloat(signOutHours * (maxHeightGraph/maxHours))

            let signOutBarView  = UIView.init(frame: CGRectMake(signInBarView.frame.size.width + signInBarView.frame.origin.x, DateView.frame.size.height-signOutHeightGraph, 10, signOutHeightGraph))
//            signOutBarView.layer.cornerRadius = 3
            
            let path1 = UIBezierPath(roundedRect:signOutBarView.bounds, byRoundingCorners:[.TopRight, .TopLeft], cornerRadii: CGSizeMake(20, 20))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.path = path1.CGPath
            signOutBarView.layer.mask = maskLayer1
            
            signOutBarView.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            DateView.addSubview(signOutBarView)

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
        
        bgLabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        bgLabel.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        self.view.addSubview(bgLabel)
        
       
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
        
        
        //// Shifts label with color symbols ////
        
        var firstLblposition :CGFloat = 11
        let viewFrameY :CGFloat = bottomLine.frame.origin.y + 4
        let labelY :CGFloat = 0
        let labelWidth :CGFloat = 50
        let padding :CGFloat = 7
        let colorLblSize :CGFloat = 11
        let colorLblY :CGFloat = 4
        
        shiftsLblBackView = UIView.init(frame: CGRectMake(0, viewFrameY, self.view.frame.size.width, 20))
        shiftsLblBackView.backgroundColor = UIColor.clearColor()
        
        for j in 0 ..< 2 {
            
            let nameLbl = UILabel.init(frame: CGRectZero)
            nameLbl.textColor = UIColor.blackColor()
            nameLbl.textAlignment = .Left
            nameLbl.font = UIFont.systemFontOfSize(9.0)
            
            
            let colorLbl = UILabel.init(frame: CGRectZero)
            colorLbl.backgroundColor = UIColor.blackColor()
            
            if j == 0 {
                nameLbl.frame = CGRectMake(shiftsLblBackView.frame.size.width - padding - labelWidth, labelY, labelWidth, shiftsLblBackView.frame.size.height)
                colorLbl.frame = CGRectMake(nameLbl.frame.origin.x - padding - colorLblSize , colorLblY, colorLblSize, colorLblSize)
                firstLblposition = colorLbl.frame.origin.x
                
                nameLbl.text = "Sign out"
                colorLbl.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
                //80 176 202
            }
            else{
                nameLbl.frame = CGRectMake(firstLblposition - padding - labelWidth, labelY, labelWidth, 20)
                colorLbl.frame = CGRectMake(nameLbl.frame.origin.x - padding - colorLblSize , colorLblY, colorLblSize, colorLblSize)
                
                nameLbl.text = "Sign in"
                colorLbl.backgroundColor = UIColor(red: 80.0/255.0, green: 176.0/255.0, blue: 202.0/255.0, alpha: 1.0)
            }
            shiftsLblBackView.addSubview(nameLbl)
            shiftsLblBackView.addSubview(colorLbl)
            
        }
        
       //// Measurement divider lines ////
        
        linesBackView = UIView.init(frame: CGRectMake(0, 0, 25, scrollView.frame.size.height))
        linesBackView.backgroundColor = UIColor.clearColor()
        
        bottomLineY = bottomLine.frame.origin.y
        var Yaxis : CGFloat = bottomLineY
        
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
        self.view.addSubview(shiftsLblBackView)
        self.view.addSubview(bottomLine)
        self.view.addSubview(scrollView)
        self.view.addSubview(linesBackView)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if (scrollView != nil){  scrollView.removeFromSuperview() }
        if (bottomLine != nil){  bottomLine.removeFromSuperview() }
        if (currentDateLbl != nil){  currentDateLbl.removeFromSuperview() }
        if (linesBackView != nil){  linesBackView.removeFromSuperview() }
        if (shiftsLblBackView != nil){  shiftsLblBackView.removeFromSuperview() }
        if (bgLabel != nil){  bgLabel.removeFromSuperview() }
        
        print("Second VC will disappear")
    }
    
    func fetchUserSignedGraphDataFromDatabase() {
        let databaseFetch = databaseFile()
        userSignedGraphDataArray = databaseFetch.getUserSignedGraphData()
        print("\(userSignedGraphDataArray)")
    }
}
