//
//  chartViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 24/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class chartViewController: UIViewController,UIScrollViewDelegate {

    var isPresented:Bool = true
    var graphBoundryLeft:UILabel! = UILabel()
    var graphBoundryTop:UILabel! = UILabel()
    var scrollView:UIScrollView!
    var scrollView2:UIScrollView!
    
    var graphleftSpace:CGFloat = 60.0
    var leftSpace:CGFloat = 0.0
    var boundryLinesWidth:CGFloat = 2.0
    var barWidth:CGFloat = 60
    var topGrphStartBoundry: CGFloat = 60.0
    var WorkSiteNamewithColorDict:NSMutableDictionary = [:]
    
    var dataArr:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
         dataDict.setObject(dataARR, forKey: "workSiteList")
         dataDict.setObject(z, forKey: "userId")
         dataDict.setObject(x, forKey: "CreatedDate")
 */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(chartViewController.rotated1), name: UIDeviceOrientationDidChangeNotification, object: nil)
       
        
        scrollView2 = UIScrollView(frame: CGRectMake(0, 0, 35, self.view.frame.size.height))
//        scrollView2.backgroundColor = UIColor.blackColor()
        scrollView2.scrollEnabled = true
        scrollView2.delegate = self
        scrollView2.backgroundColor = UIColor.clearColor()
        scrollView2.contentOffset = CGPoint(x: 0, y: 0)
        scrollView2.contentSize = CGSizeMake(0, 600)
        
        
        
        
        self.view.addSubview(scrollView2)
        
        
        graph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

    func graph(){
//-->
        let database = databaseFile()
        var graphArr:NSMutableArray = []
        let WorkSiteNameArr:NSMutableArray = []
        var userId = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUSerID")!)"

        graphArr = database.getUserWorksiteActivityGraph(userId)
        

        print(graphArr)
        for i:Int in 0 ..< graphArr.count {
            let dict:NSMutableDictionary = graphArr[i] as! NSMutableDictionary
            
            let locArr = (dict.valueForKey("workSiteList") as! NSArray)
            for j:Int in 0 ..< locArr.count{
                let locdict:NSDictionary = locArr[j] as! NSDictionary
                if WorkSiteNameArr.containsObject("\(locdict.valueForKey("WorkSiteName")!)") {
                }else{
                    WorkSiteNameArr.addObject("\(locdict.valueForKey("WorkSiteName")!)")
                }
                
            }
        }
        for a:Int in 0 ..< WorkSiteNameArr.count {
            WorkSiteNamewithColorDict.setObject(getRandomColor(), forKey: "\(WorkSiteNameArr[a])")
        }
        scrollView2.contentSize = CGSizeMake(0, CGFloat(WorkSiteNameArr.count) * 200)
        
        var y:CGFloat = 0
        
        for (var a=0;a<WorkSiteNameArr.count;a++){
            let lbl = UILabel(frame: CGRectMake(-scrollView2.frame.size.width*2-12, y + 100, 200, scrollView2.frame.size.width))
            lbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            lbl.text = "\(WorkSiteNameArr[a] as! String)"
            lbl.textAlignment = .Center
            lbl.backgroundColor = WorkSiteNamewithColorDict.valueForKey(WorkSiteNameArr[a] as! String) as! UIColor
            scrollView2.addSubview(lbl)
            y = y + 200
        }
        
//-->
         scrollView = UIScrollView(frame: CGRectMake(graphleftSpace, leftSpace, self.view.frame.size.width-graphleftSpace-5, self.view.frame.size.height-leftSpace-20))
//        scrollView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(scrollView)
        
        graphBoundryLeft = UILabel(frame: CGRectMake(0, topGrphStartBoundry, boundryLinesWidth, scrollView.frame.size.height-topGrphStartBoundry))
        graphBoundryLeft.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(graphBoundryLeft)
        
        // display hours labels on the left divide in four parts 0 6 12 18 24
        let height = graphBoundryLeft.frame.size.height/4
        var val:CGFloat = 0.0
        var hourtxt:Int = 0
        for(var x=0;x<5;x+=1){
        let hourslbl = UILabel(frame: CGRectMake(25 , scrollView.frame.origin.y + topGrphStartBoundry + val - 5, scrollView.frame.origin.x-10, 20))
            hourslbl.textAlignment = .Center
            hourslbl.text = "\(hourtxt)hr."
            hourslbl.font = hourslbl.font.fontWithSize(10)
            hourslbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            self.view.addSubview(hourslbl)
            val = val + height
            hourtxt = hourtxt + 6
        }
        
        
        graphBoundryTop = UILabel(frame: CGRectMake(0, topGrphStartBoundry, scrollView.frame.size.width, boundryLinesWidth))
        graphBoundryTop.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(graphBoundryTop)
        
        var xViewValue:CGFloat = 0.0
        let dataaaArr:NSMutableArray = []
        let differentValues:NSArray = [2,6,1,8,4,0]
        let differentValues1:NSArray = [3,4,8,1,6,2]
        let differentValues2:NSArray = [5,0,5,2,0,0]
        let differentValues3:NSArray = [8,0,6,1,1,1]
         dataaaArr.addObject(differentValues)
         dataaaArr.addObject(differentValues1)
         dataaaArr.addObject(differentValues2)
         dataaaArr.addObject(differentValues3)
        
        for(var x=0;x<graphArr.count;x+=1){
             let dict:NSMutableDictionary = graphArr[x] as! NSMutableDictionary
            var  CreatedDate:String = "\(dict.valueForKey("CreatedDate")!)"
            let workSiteListArr = (dict.valueForKey("workSiteList") as! NSArray)
            CreatedDate = "\(CreatedDate.componentsSeparatedByString("-")[2])-\(CreatedDate.componentsSeparatedByString("-")[0])-\(CreatedDate.componentsSeparatedByString("-")[1])T00:00:00"
            CreatedDate = convertDate(CreatedDate)
            
            "yyyy-MM-dd'T'HH:mm:ss"
           //creating the view for background of labels
            let graphView = UIView(frame: CGRectMake(10*CGFloat(x) + xViewValue + 10, topGrphStartBoundry + 2, barWidth, scrollView.frame.size.height-topGrphStartBoundry))
//            graphView.backgroundColor = UIColor.darkGrayColor()
            self.scrollView.addSubview(graphView)
            xViewValue = xViewValue + barWidth
            
            // adding dates
            let dateslbl = UILabel(frame: CGRectMake(graphView.frame.origin.x, 0, graphView.frame.size.width, topGrphStartBoundry))
            dateslbl.textAlignment = .Center
            dateslbl.text = CreatedDate
            dateslbl.font = dateslbl.font.fontWithSize(12)
            dateslbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            self.scrollView.addSubview(dateslbl)

            
            
            // loop for creating inner labels
            var xValue:CGFloat = 0.0
            let area24 = graphView.frame.size.height/(24*60)
            
            
            
            
            for(var y=0;y<workSiteListArr.count;y+=1){
                let locDict = workSiteListArr[y] as! NSDictionary
                let height = "\(locDict.valueForKey("WorkingHour")!)"
                let WorkSiteName = "\(locDict.valueForKey("WorkSiteName")!)"
                print(Float(height))
               let heightCGFloat:CGFloat = CGFloat(Float(height)!)
                
                var  TimeInStr = "\(locDict.valueForKey("TimeIn")!)"
                let hr = Int(TimeInStr.componentsSeparatedByString(":")[0])! * 60
                let min = Int(TimeInStr.componentsSeparatedByString(":")[1])!
                let total = hr + min
                TimeInStr = "\(total)"
                
                
                let TimeInStrCGfloat:CGFloat = CGFloat(Float(TimeInStr)!)
                
                
                //(0 26.4333; 60 3.49056)
             let label = UILabel(frame: CGRectMake(0, area24 * TimeInStrCGfloat , graphView.frame.size.width, area24 * heightCGFloat * 60 ))
                
//                label.layer.borderColor = UIColor.blackColor().CGColor;
//                label.layer.borderWidth = 1.0;
//                label.text = WorkSiteName
//                label.font = dateslbl.font.fontWithSize(10)
                label.backgroundColor = WorkSiteNamewithColorDict.valueForKey(WorkSiteName) as! UIColor
                
                
             graphView.addSubview(label)
             xValue = xValue + label.frame.size.height
            
            }

            
        }
        
    }

    func convertDate(dateStr:String)-> String{
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        let date: NSDate = dateFormatter.dateFromString(dateStr)!
                    // create date from string
                    // change to a readable time format and change to local time zone
//        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        dateFormatter.dateFormat = "MMM d"

        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let timestamp: String = dateFormatter.stringFromDate(date)
        return timestamp
    }
    func rotated1()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            
            print("chart landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("chart Portrait")
            self.dismissViewControllerAnimated(true, completion: {});
            self.navigationController?.popViewControllerAnimated(true)
        
        }
        
    }

}
