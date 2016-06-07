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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var scrollView: UIScrollView!
    var bottomLine: UILabel!
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
        
        scrollView = UIScrollView.init(frame: CGRectMake(8, 0, self.view.frame.size.width-8, 200))
        scrollView.backgroundColor = UIColor.clearColor()
        dateArray = WeekView.showdates()
        var Xaxis: CGFloat = 10

        if (dateArray == nil || dateArray.count == 0) {
            return
        }
        var bottomLineY :CGFloat = 100
        let dateViewWidth: CGFloat = scrollView.frame.size.width/7

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
                let DateBgLbl = UILabel.init(frame: CGRectMake(x, y, DateLabel.frame.size.width - 14, DateLabel.frame.size.height))
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

            let maxBarHeight : CGFloat = 24.0
            let diceRoll = Int(arc4random_uniform(24) + 1)
            let barheight : CGFloat = CGFloat(5 * maxBarHeight)
            let barView  = UIView.init(frame: CGRectMake(DateView.frame.size.width/2-5, DateView.frame.size.height-barheight+7, 10, barheight))
            barView.layer.cornerRadius = 3
            barView.backgroundColor = UIColor(red: 210.0/255.0, green: 52.0/255.0, blue: 53.0/255.0, alpha: 1.0)
            
            barView.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)

            
            DateView.addSubview(barView)

            bottomLineY = DateView.frame.size.height

        }
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(Xaxis,150)
        
        bottomLine = UILabel.init(frame: CGRectMake(scrollView.frame.origin.x, bottomLineY, self.view.frame.size.width, 1))
        bottomLine.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        let bgLabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        bgLabel.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        self.view.addSubview(bgLabel)
        
        let currentDateLbl = UILabel.init(frame: CGRectMake(0,50, self.view.frame.size.width, 20))
        currentDateLbl.textColor = UIColor.blackColor()
        currentDateLbl.textAlignment = .Center
        currentDateLbl.font = UIFont.systemFontOfSize(11.0)
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d MMM,yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateStr: String = dateFormatter.stringFromDate(NSDate())
        currentDateLbl.text = "\(dateStr)"
        
        var firstLblposition :CGFloat = 11
        let labelY :CGFloat = bottomLine.frame.origin.y + 4
        let labelWidth :CGFloat = 50
        let padding :CGFloat = 7
        let colorLblSize :CGFloat = 11
        let colorLblY :CGFloat = bottomLine.frame.origin.y + 8

        for j in 0 ..< 2 {
           
            let shiftNameLbl = UILabel.init(frame: CGRectZero)
            shiftNameLbl.textColor = UIColor.blackColor()
            shiftNameLbl.textAlignment = .Left
            shiftNameLbl.font = UIFont.systemFontOfSize(9.0)
            
            
            let shiftColorLbl = UILabel.init(frame: CGRectZero)
            shiftColorLbl.backgroundColor = UIColor.blackColor()
            
            if j == 0 {
                shiftNameLbl.frame = CGRectMake(self.view!.frame.size.width - padding - labelWidth, labelY, labelWidth, 20)
                shiftColorLbl.frame = CGRectMake(shiftNameLbl.frame.origin.x - padding - colorLblSize , colorLblY, colorLblSize, colorLblSize)
                firstLblposition = shiftColorLbl.frame.origin.x
                
                shiftNameLbl.text = "Night Shift"
                shiftColorLbl.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)

            }
            else{
                shiftNameLbl.frame = CGRectMake(firstLblposition - padding - labelWidth, labelY, labelWidth, 20)
                shiftColorLbl.frame = CGRectMake(shiftNameLbl.frame.origin.x - padding - colorLblSize , colorLblY, colorLblSize, colorLblSize)

                shiftNameLbl.text = "Day Shift"
                shiftColorLbl.backgroundColor = UIColor(red: 210.0/255.0, green: 52.0/255.0, blue: 53.0/255.0, alpha: 1.0)
            }
            self.view.addSubview(shiftNameLbl)
            self.view.addSubview(shiftColorLbl)

        }
        
        
        var Yaxis : CGFloat = 80
        for k in 1 ..< 25 {
            
            let lineLbl = UILabel.init(frame: CGRectZero)
            lineLbl.backgroundColor = UIColor.blackColor()
            
            
            if( k%4 == 0 || k == 0){
                lineLbl.frame = CGRectMake(0,Yaxis, 10, 0.5)
                Yaxis = 80 + CGFloat(k) * 5.0
            }
        
            self.view.addSubview(lineLbl)
        }
        
       
        self.view.addSubview(currentDateLbl)
        self.view.addSubview(bottomLine)
        self.view.addSubview(scrollView)

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.removeFromSuperview()
        bottomLine.removeFromSuperview()
        print("Second VC will disappear")
    }
    
}
