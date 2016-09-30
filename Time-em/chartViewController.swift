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
    var barWidth:CGFloat = 35
    var topGrphStartBoundry: CGFloat = 60.0
    var WorkSiteNamewithColorDict:NSMutableDictionary = [:]
    var name:String! = nil
    var dataArr:NSMutableArray = []
    
     // MARK: Default functions
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
    
    override func viewDidAppear(animated: Bool) {
        
    }

    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

     // MARK: graph
    func graph(){
        //-->
        let database = databaseFile()
        var graphArr:NSMutableArray = []
        let WorkSiteNameArr:NSMutableArray = []
        let userId = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUSerID")!)"

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
        
        for a in (0 ..< WorkSiteNameArr.count){
            let lbl = UILabel(frame: CGRectMake(-scrollView2.frame.size.width*2-12, y + 100, 200, scrollView2.frame.size.width))
            lbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            lbl.text = "\(WorkSiteNameArr[a] as! String)"
            lbl.textAlignment = .Center
            lbl.backgroundColor = WorkSiteNamewithColorDict.valueForKey(WorkSiteNameArr[a] as! String) as? UIColor
            scrollView2.addSubview(lbl)
            y = y + 200
        }
        
//-->
        let label = UILabel(frame: CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.height, 35))
        //label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        let name:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUserFullName")!)"
        label.text = name
         label.textColor = UIColor.whiteColor()
//        label.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        label.backgroundColor = UIColor(red: 23/256, green: 33/256, blue: 52/256, alpha: 1)
        self.view.addSubview(label)
        
        
        let  transA = CGAffineTransformMakeTranslation(label.frame.size.width/2,label.frame.size.height/2);
        let  rotation = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
        let  transB = CGAffineTransformMakeTranslation(-label.frame.size.width/2,-label.frame.size.height/2);
        
        
        let transform = CGAffineTransformConcat(CGAffineTransformConcat(transA,rotation),transB);
        
        label.transform = CGAffineTransformConcat(label.transform, transform)
        
        
        
         scrollView = UIScrollView(frame: CGRectMake(graphleftSpace, leftSpace, self.view.frame.size.width-graphleftSpace-label.frame.size.width, self.view.frame.size.height-leftSpace-20))
        scrollView.backgroundColor = UIColor(red: 21/256, green: 25/256, blue: 35/256, alpha: 1)
        self.view.addSubview(scrollView)
        
        
        
        graphBoundryTop = UILabel(frame: CGRectMake(0, topGrphStartBoundry, scrollView.frame.size.width, boundryLinesWidth))
        graphBoundryTop.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(graphBoundryTop)
        
        //-----------
        let backLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width, topGrphStartBoundry))
        //label.center = CGPointMake(160, 284)
        backLabel.textAlignment = NSTextAlignment.Center
        backLabel.text = ""
        //        label.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        backLabel.backgroundColor = UIColor(red: 32/256, green: 44/256, blue: 66/256, alpha: 1)
        self.view.addSubview(backLabel)
        self.view.bringSubviewToFront(label)
        
        
        
        graphBoundryLeft = UILabel(frame: CGRectMake(0, topGrphStartBoundry, boundryLinesWidth, scrollView.frame.size.height-topGrphStartBoundry))
        graphBoundryLeft.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(graphBoundryLeft)
        
        // display hours labels on the left divide in four parts 0 6 12 18 24
        let height = graphBoundryLeft.frame.size.height/4
        var val:CGFloat = 0.0
        var hourtxt:Int = 0
        for x in (0 ..< 5){
        let hourslbl = UILabel(frame: CGRectMake(25 , scrollView.frame.origin.y + topGrphStartBoundry + val - 5, scrollView.frame.origin.x-10, 20))
            hourslbl.textAlignment = .Center
            hourslbl.text = "\(hourtxt)hr."
            hourslbl.textColor = UIColor.whiteColor()
            hourslbl.font = hourslbl.font.fontWithSize(10)
            hourslbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            self.view.addSubview(hourslbl)
            val = val + height
            hourtxt = hourtxt + 6
            
        let partitionLinelbl = UILabel(frame: CGRectMake(0 , scrollView.frame.origin.y + topGrphStartBoundry + val - 1, scrollView.frame.size.width, 1))
//            partitionLinelbl.backgroundColor = UIColor.whiteColor()
            partitionLinelbl.addDashedLine(UIColor(red: 32/256, green: 44/256, blue: 66/256, alpha: 1))
            self.scrollView.addSubview(partitionLinelbl)
          
        if (x == 0 || x == 2) {
            let lblbackgroundColor = UILabel(frame: CGRectMake(boundryLinesWidth , scrollView.frame.origin.y + topGrphStartBoundry + val - 1, scrollView.frame.size.width, height))
             lblbackgroundColor.backgroundColor = UIColor(red: 16/256, green: 19/256, blue: 26/256, alpha: 1)
//            lblbackgroundColor.addDashedLine(UIColor(red: 32/256, green: 44/256, blue: 66/256, alpha: 1))
            self.scrollView.addSubview(lblbackgroundColor)
            }
            
        }
       
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
        
        for x in (0 ..< graphArr.count){
             let dict:NSMutableDictionary = graphArr[x] as! NSMutableDictionary
            var  CreatedDate:String = "\(dict.valueForKey("CreatedDate")!)"
            let workSiteListArr = (dict.valueForKey("workSiteList") as! NSArray)
            CreatedDate = "\(CreatedDate.componentsSeparatedByString("-")[2])-\(CreatedDate.componentsSeparatedByString("-")[0])-\(CreatedDate.componentsSeparatedByString("-")[1])T00:00:00"
            CreatedDate = convertDate(CreatedDate)
            
            "yyyy-MM-dd'T'HH:mm:ss"
           //creating the view for background of labels
            let graphView = UIView(frame: CGRectMake(10*CGFloat(x) + xViewValue - 5, topGrphStartBoundry + 2, barWidth, scrollView.frame.size.height-topGrphStartBoundry))
//            graphView.backgroundColor = UIColor.darkGrayColor()
            self.scrollView.addSubview(graphView)
            xViewValue = xViewValue + barWidth
            
            // adding dates
            let dateslbl = UILabel(frame: CGRectMake(graphView.frame.origin.x + scrollView.frame.origin.x, 0 , graphView.frame.size.width + 30, topGrphStartBoundry))
            dateslbl.textAlignment = .Center
            dateslbl.text = CreatedDate
            dateslbl.textColor = UIColor.whiteColor()
            dateslbl.font = dateslbl.font.fontWithSize(12)
            dateslbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            self.view.addSubview(dateslbl)
            self.view.bringSubviewToFront(dateslbl)
//            let datesDottedlbl = UILabel(frame: CGRectMake(graphView.frame.origin.x, topGrphStartBoundry, graphView.frame.size.width, topGrphStartBoundry))
//            datesDottedlbl.backgroundColor = UIColor.whiteColor()
//            self.scrollView.addSubview(datesDottedlbl)
            
            // loop for creating inner labels
            var xValue:CGFloat = 0.0
            let area24 = graphView.frame.size.height/(24*60)
            
            
            
            
            for y in (0 ..< workSiteListArr.count){
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
            if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft{
                 print("chart LandscapeLeft")
            }
            else if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight{
                 print("chart LandscapeRight")
                
//         self.view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
                
            }
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("chart Portrait")
            self.dismissViewControllerAnimated(true, completion: {});
            self.navigationController?.popViewControllerAnimated(true)
        
        }
        
    }
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        
//        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
//        {
//            print("chart landscape")
//            if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft{
//                print("chart LandscapeLeft")
//                return UIInterfaceOrientationMask.AllButUpsideDown
//            }
//            else if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight{
//                print("chart LandscapeRight")
//              return UIInterfaceOrientationMask.AllButUpsideDown
//            }
//            
//        }
//        return UIInterfaceOrientationMask.Portrait
//    }
//    func orientation(){
//        delay(0.001){
//        UIView.animateWithDuration(2.0, animations: {
//            self.view.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
//        })
//        }
//    }
}
extension UILabel {
    func addDashedLine(color: UIColor = UIColor.lightGrayColor()) {
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        self.backgroundColor = UIColor.clearColor()
        let cgColor = color.CGColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4, 4]
        
        let path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, self.frame.width, 0)
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}
