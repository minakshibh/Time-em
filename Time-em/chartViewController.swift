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
    
    var graphleftSpace:CGFloat = 20.0
    var leftSpace:CGFloat = 0.0
    var boundryLinesWidth:CGFloat = 2.0
    var barWidth:CGFloat = 35
    var topGrphStartBoundry: CGFloat = 60.0
    var WorkSiteNamewithColorDict:NSMutableDictionary = [:]
    var name:String! = nil
    var dataArr:NSMutableArray = []
    var WorksiteListArr:NSArray = []
     var CreatedDateStr:NSString = ""
         var SiteNameString:NSString = ""
   var  SiteNameStr:NSArray=[]
      var graphDict:NSMutableDictionary = [:]
    
     // MARK: Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
//         dataDict.setObject(dataARR, forKey: "workSiteList")
//         dataDict.setObject(z, forKey: "userId")
//         dataDict.setObject(x, forKey: "CreatedDate")
//
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(chartViewController.rotated1), name: UIDeviceOrientationDidChangeNotification, object: nil)
       
        
        scrollView2 = UIScrollView(frame: CGRectMake (0, 0, 35, self.view.frame.size.height))
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
    
    override func shouldAutorotate() -> Bool {
        return true
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
      //  var graphDict:NSMutableDictionary = [:]
        let WorkSiteNameArr:NSMutableArray = []
        let userId = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUSerID")!)"
        graphDict = database.getUserWorksiteActivityGraph(userId)
        
        let total = graphDict.allKeys.count
        
        if total > 0 {
        }
            
        else {
            
            let alert = UIAlertController(title: "Time'em", message: "Tracking plot not available for this user.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                
                self.dismissViewControllerAnimated(true, completion: {});
                self.navigationController?.popViewControllerAnimated(true)
                
                
            }))
            
            alert.shouldAutorotate()
            self.presentViewController(alert, animated: true, completion: {() -> Void in
//               
//            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
//                {
//                    
//                    print("chart landscape")
//                    if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft{
//                        print("chart LandscapeLeft")
//                        
//                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
//                            alert.view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
//                        }) { (finished) -> Void in
//                            // do something if you need
//                        }
//                        
//                    }
//                }
//            else if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight{
//                
//                        print("chart LandscapeRight")
//                       
//                        UIView.animateWithDuration(1.0, delay: 0, options: .CurveLinear, animations: { () -> Void in
//                            alert.view.transform = CGAffineTransformMakeRotation(CGFloat(3 * M_PI_2))
//                        }) { (finished) -> Void in
//                            // do something if you need
//                        }
//
//                }
//            
//           
               })
            return;
 
        }
        
        
        
        
        var y:CGFloat = 0
        

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
       // scrollView.backgroundColor = UIColor(red: 21/256, green: 25/256, blue: 35/256, alpha: 1)
        scrollView.backgroundColor = UIColor .blackColor()
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
       //  backLabel.backgroundColor = UIColor .blackColor()
        self.view.addSubview(backLabel)
        self.view.bringSubviewToFront(label)

        let dateARR:NSMutableArray = []
        print(graphDict)
        let keyArray = graphDict.allKeys as NSArray
        var noOfArraysInAKey:NSMutableArray = []
        
if keyArray.count > 0 {
    for (var g = 0; g < keyArray.count ; g++ ){
            
         noOfArraysInAKey = graphDict.valueForKey("\(keyArray[g])") as! NSMutableArray
        
        for i:Int in 0 ..< noOfArraysInAKey.count {
            let dict:NSMutableDictionary = noOfArraysInAKey[i] as! NSMutableDictionary
            print("dict" ,dict)
            
            SiteNameStr = keyArray as NSArray
//            let SiteNameString:NSString = SiteNameStr.firstObject as! NSString
            
            let WorksiteDatesDictionary:NSMutableDictionary = dict.valueForKey("WorksiteDates") as! NSMutableDictionary
//            WorksiteListArr = WorksiteDatesDictionary .valueForKey("workSiteList") as! NSArray
            CreatedDateStr = WorksiteDatesDictionary .valueForKey("CreatedDate") as! NSString
            if !dateARR.containsObject(CreatedDateStr){
               dateARR.addObject(CreatedDateStr)
            }
        }
    }
}
//        for a:Int in 0 ..< SiteNameStr.count {
//            WorkSiteNamewithColorDict.setObject(getRandomColor(), forKey: "\(WorksiteListArr[a])")
//        }
//        scrollView2.contentSize = CGSizeMake(0, CGFloat(SiteNameStr.count) * 200)
        
        
        
        
        
        graphBoundryLeft = UILabel(frame: CGRectMake(0, topGrphStartBoundry, 100, scrollView.frame.size.height-topGrphStartBoundry + 20))
        graphBoundryLeft.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(graphBoundryLeft)
        
        // display hours labels on the left divide in four parts 0 6 12 18 24
        let height = (graphBoundryLeft.frame.size.height - 10)/5
        var val:CGFloat = 0.0
        var hourtxt:NSString = ""
        
        for x:Int in 0 ..< dateARR.count {
        let hourslbl = UILabel(frame: CGRectMake(-30, scrollView.frame.origin.y + topGrphStartBoundry + val + 40, scrollView.frame.origin.x+60, 20))
            hourslbl.textAlignment = .Center
            
            let setdateFormat:String = "\(dateARR[x])" as String
    

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let datestr = dateFormatter.dateFromString(setdateFormat)
            
           //  let dateFormatt = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let goodDate = dateFormatter.stringFromDate(datestr!)
            hourslbl.text = goodDate

           // hourslbl.text = "\(dateARR[x])" as String
            hourslbl.textColor = UIColor.whiteColor()
            
            hourslbl.font = hourslbl.font.fontWithSize(13)
            hourslbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            self.view.addSubview(hourslbl)
            val = val + height
          //  hourtxt = hourtxt + 6
            
        let partitionLinelbl = UILabel(frame: CGRectMake(0 , scrollView.frame.origin.y + topGrphStartBoundry + val , scrollView.frame.size.width, 1))
           // partitionLinelbl.backgroundColor = UIColor.whiteColor()
            partitionLinelbl.addDashedLine(UIColor(red: 32/256, green: 44/256, blue: 66/256, alpha: 1))
            self.scrollView.addSubview(partitionLinelbl)

            print("partitionLinelbl --- \(scrollView.frame.origin.y + topGrphStartBoundry + val - 1)")
        }
       
        var xViewValue:CGFloat = 5.0
        
        //var WorksiteListArr:NSArray = []
        var flag:NSString = " "
        let newArray:NSMutableArray = []
//        for x in (0 ..< graphArr.count){
        
        
    for x:Int in 0 ..< keyArray.count {

        let siteDataArr:NSMutableArray = graphDict.valueForKey("\(keyArray[x])") as! NSMutableArray
        
        //>>creating the view for background of labels
        let graphView = UIView(frame: CGRectMake(20*CGFloat(x) + xViewValue , topGrphStartBoundry + 2, barWidth + 18, scrollView.frame.size.height-topGrphStartBoundry))//+ 18  for dotted line
        graphView.addDashedBorderToView()
        self.scrollView.addSubview(graphView)
        
        
//        graphView.backgroundColor = UIColor.purpleColor()
        
        
        
        
        
        let upperDottedLine = UILabel(frame: CGRectMake(graphView.frame.origin.x , 0, 1, self.scrollView.frame.size.height))
        upperDottedLine.addDashedLine(UIColor(red: 32/256, green: 44/256, blue: 66/256, alpha: 1))
         self.scrollView.addSubview(upperDottedLine)
    //    upperDottedLine.backgroundColor = UIColor.grayColor()
       
     
        let lowerDottedLine = UILabel(frame: CGRectMake(graphView.frame.origin.x + graphView.frame.size.width, 0, 1,self.scrollView.frame.size.height))
       lowerDottedLine.addDashedLine(UIColor(red: 32/256, green: 44/256, blue: 66/256, alpha: 1))
           self.scrollView.addSubview(lowerDottedLine)
          self.scrollView.bringSubviewToFront(lowerDottedLine)
        

         xViewValue = xViewValue + barWidth
        
//        let topBorder: CALayer = CALayer()
//        topBorder.frame = CGRectMake(0.0, 0.0, graphView.frame.size.width, 3.0)
//        topBorder.backgroundColor = UIColor.redColor().CGColor
//        graphView.layer.addSublayer(topBorder)
        
        //>> display labels to divide screen horizontally
        let height = graphBoundryTop.frame.size.width
//        var val:CGFloat = 0.0
//        let dateslbl:NSString = " "
        
        
             let dict:NSMutableDictionary = siteDataArr[x] as! NSMutableDictionary
        
            
            //------------------------------->>>>>>>>>>>>>>>>>>>>>
            //New Changes
            
            let SiteNameStr:NSArray = keyArray as! NSArray
              let SiteNameString:NSString = "\(keyArray[x])"
            
             if newArray.containsObject(SiteNameString)
             {
                 flag = "1"
            }
            else
             {
                 newArray.addObject(SiteNameString)
                flag = "0"
            }
           
             let WorksiteDatesDictionary:NSMutableDictionary = dict.valueForKey("WorksiteDates") as! NSMutableDictionary
//               WorksiteListArr = WorksiteDatesDictionary .valueForKey("workSiteList") as! NSArray
                var CreatedDateStr:NSString = WorksiteDatesDictionary .valueForKey("CreatedDate") as! NSString
            
            
         //   var  CreatedDate:String = "\(dict.valueForKey("CreatedDate")!)"
            
            print("printCreatedDateStr",CreatedDateStr)
            
          //  let workSiteListArr = (dict.valueForKey("workSiteList") as! NSArray)
            CreatedDateStr = "\(CreatedDateStr.componentsSeparatedByString("-")[2])-\(CreatedDateStr.componentsSeparatedByString("-")[0])-\(CreatedDateStr.componentsSeparatedByString("-")[1])T00:00:00"
                print("print data:",CreatedDateStr)
            
            CreatedDateStr = convertDate(CreatedDateStr as String)
            "yyyy-MM-dd'T'HH:mm:ss"

            if flag == "0"
            {
                    flag = "1"
                    let dateslbl = UILabel(frame: CGRectMake(graphView.frame.origin.x + scrollView.frame.origin.x ,-10,graphBoundryLeft.frame.origin.y - 5, graphView.frame.size.width + 30 ))//graphBoundryLeft.frame.origin.y
                    dateslbl.textAlignment = .Left
                    dateslbl.text = "\(keyArray[x])"
                    dateslbl.textColor = UIColor.whiteColor()
                    dateslbl.font = dateslbl.font.fontWithSize(12)
                    dateslbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                    dateslbl.numberOfLines = 2
                dateslbl.lineBreakMode = NSLineBreakMode.ByWordWrapping

                    self.view.addSubview(dateslbl)
                    self.view.bringSubviewToFront(dateslbl)
                
//                let upperDottedLine = UILabel(frame: CGRectMake(graphView.frame.origin.x , 0, 1, scrollView.frame.size.height))
//                upperDottedLine.addDashedLine(UIColor.whiteColor())
//                upperDottedLine.backgroundColor = UIColor.blueColor()
//                self.scrollView.addSubview(upperDottedLine)
              //  self.scrollView.bringSubviewToFront(upperDottedLine)
            
        }
        
            // loop for creating inner labels
            var xValue:CGFloat = 0.0
              let ShowLabel = graphView.frame.size.height/5
            let area24 = graphView.frame.size.height/(24*60)
            let width = (graphView.frame.size.height)/5
          let  showDateData = width/(24*60)

//                if !(SiteNameStr.count == 0)
//                {
        
            var widthPerDate:CGFloat = 0
//              (graphBoundryLeft.frame.size.height)/5
        
        var color:UIColor = getRandomColor()
        
    for y in (0 ..< siteDataArr.count){
                let locDict1 = siteDataArr[y] as! NSDictionary
               let locDict2 = locDict1.valueForKey("WorksiteDates") as! NSDictionary
                let locDict3 = locDict2.valueForKey("workSiteList") as! NSArray
            for y in (0 ..< locDict3.count){
                
                let locDict = locDict3[y] as! NSDictionary
            
                if locDict.count == 0 {
                    continue
                }
                
                let dateStr:String = locDict2.valueForKey("CreatedDate") as! String
                var increment:NSInteger!
                if dateARR.containsObject(dateStr){
                    increment = dateARR.indexOfObject(dateStr)
                }
                
                
                
                print(dateARR)
                
                
                if locDict.count == 0 {
                    continue
                }
                
//                   if (locDict.valueForKey("WorkingHour") != nil)
//                   {
//                
//                let height = "\(locDict.valueForKey("WorkingHour")!)"
//                    
//                }
//                let WorkSiteName = "\(locDict.valueForKey("WorkSiteName")!)"
//                print(Float(height))
//               let heightCGFloat:CGFloat = CGFloat(Float(height))
                let  TimeInStr = "\(locDict.valueForKey("TimeIn")!)"
                    var textArr = TimeInStr.componentsSeparatedByString(":")
                    let hr = textArr[0]
                    let min = textArr[1]
                     let TimeInTotal = (Int(hr)! * 60) + Int(min)!
                   let TimeInTotalFloat =  CGFloat(TimeInTotal)
                  
                   //  let TimeInStrCGfloat:CGFloat = CGFloat(Float(TimeInStr)!)
                var TimeOutStr = "\(locDict.valueForKey("TimeOut")!)"
                if TimeOutStr == "" {
                   TimeOutStr = "00:00"
                }
                    var OuttextArr = TimeOutStr.componentsSeparatedByString(":")
                    let hr1 = OuttextArr[0]
                    let min1 = OuttextArr[1]
                    let TimeOutTotal = (Int(hr1)! * 60) + Int(min1)!
                    //let TimeOutTotalFloat = Float(TimeOutTotal)
                    let TimeOutTotalFloat =  CGFloat(TimeOutTotal)
                
                print("TimeInTotalFloat  ",TimeInTotalFloat)
                print("TimeOutTotalFloat  ",TimeOutTotalFloat)
                print("showDate::",showDateData * TimeOutTotalFloat - showDateData * TimeInTotalFloat)
                print("Date::",showDateData * TimeInTotalFloat)
                print("showDate::",showDateData)
                
                var calculatedheight:CGFloat = showDateData * TimeOutTotalFloat - showDateData * TimeInTotalFloat
                
                if TimeOutTotalFloat == 0{
                    calculatedheight = 0
                }
                
             let label = UIView(frame: CGRectMake(0, width * CGFloat(increment) + showDateData * TimeInTotalFloat ,graphView.frame.size.width,calculatedheight))
                print(label.frame)
                
//                label.layer.borderColor = UIColor.whiteColor().CGColor;
//                label.layer.borderWidth = 1.0;
                    
            label.backgroundColor = color
                
             graphView.addSubview(label)
             xValue = xValue + label.frame.size.height
//                widthPerDate = widthPerDate + width;
        }
        }
                
//        }
    }
}
    
    func convertDate(dateStr:String)-> String{
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
         let date: NSDate = dateFormatter.dateFromString(dateStr)!
        
        
       // let date: NSDate = dateFormatter.dateFromString(dateStr)!
        
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
            
            
            //  if graphDict.count < 0
          //  let dic = NSDictionary()
       
            
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
        shapeLayer.lineDashPattern = [2, 2]
        
        let path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, self.frame.width, 0)
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}
extension UIView {
    func addDashedBorderToView() {
        let color = (UIColor(red: 32/256, green: 44/256, blue: 66/256, alpha: 1)).CGColor

        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [2,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).CGPath
        
        self.layer.addSublayer(shapeLayer)
    }
}


