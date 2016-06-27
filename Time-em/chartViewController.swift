//
//  chartViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 24/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class chartViewController: UIViewController {

    var isPresented:Bool = true
    var graphBoundryLeft:UILabel! = UILabel()
    var graphBoundryTop:UILabel! = UILabel()
    var scrollView:UIScrollView!
    
    
    var graphleftSpace:CGFloat = 40.0
    var leftSpace:CGFloat = 0.0
    var boundryLinesWidth:CGFloat = 2.0
    var barWidth:CGFloat = 60
    var topGrphStartBoundry: CGFloat = 60.0
    
    var dataArr:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dict:NSMutableDictionary = [:]
        dict.setValue("121", forKey: "Id")
        dict.setValue("parv", forKey: "name")
        dict.setValue("3", forKey: "hours")
        
        let dict1:NSMutableDictionary = [:]
        dict1.setValue(dict, forKey: "data")
        dataArr.addObject(dict1)
        
        
        let dict2:NSMutableDictionary = [:]
        dict2.setValue("121", forKey: "Id")
        dict2.setValue("parv", forKey: "name")
        dict2.setValue("4", forKey: "hours")
        
        let dict3:NSMutableDictionary = [:]
        dict3.setValue(dict1, forKey: "data")
        dataArr.addObject(dict3)
        
        let dict4:NSMutableDictionary = [:]
        dict4.setValue("121", forKey: "Id")
        dict4.setValue("parv", forKey: "name")
        dict4.setValue("6", forKey: "hours")
        
        let dict5:NSMutableDictionary = [:]
        dict5.setValue(dict1, forKey: "data")
        dataArr.addObject(dict5)
        
        
        
        graph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func graph(){
        
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
        let hourslbl = UILabel(frame: CGRectMake(0, scrollView.frame.origin.y + topGrphStartBoundry + val - 20, scrollView.frame.origin.x, 30))
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
        
        for(var x=0;x<dataaaArr.count;x+=1){
           //creating the view for background of labels
            let graphView = UIView(frame: CGRectMake(10*CGFloat(x) + xViewValue + 10, topGrphStartBoundry + 2, barWidth, scrollView.frame.size.height-topGrphStartBoundry))
//            graphView.backgroundColor = UIColor.darkGrayColor()
            self.scrollView.addSubview(graphView)
            xViewValue = xViewValue + barWidth
            
            // adding dates
            let dateslbl = UILabel(frame: CGRectMake(graphView.frame.origin.x, 0, graphView.frame.size.width, topGrphStartBoundry))
            dateslbl.textAlignment = .Center
            dateslbl.text = "27-6"
            dateslbl.font = dateslbl.font.fontWithSize(12)
            dateslbl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            self.scrollView.addSubview(dateslbl)

            var differentValArr:NSArray = []
           differentValArr = dataaaArr[x] as! NSArray
            
            // loop for creating inner labels
            var xValue:CGFloat = 0.0
            let area24 = graphView.frame.size.height/24
            
            
            
            let differentColorValues:NSArray = [UIColor.redColor(),UIColor.darkGrayColor(),UIColor.yellowColor(),UIColor.grayColor(),UIColor.greenColor(),UIColor.purpleColor()]
            
            for(var y=0;y<differentValArr.count;y+=1){
                if differentValArr[y] as! NSNumber == 0 {
                     xValue = xValue + 10
                continue
                }
             let label = UILabel(frame: CGRectMake(0, 0 + xValue, graphView.frame.size.width, area24 * CGFloat(differentValArr[y] as! NSNumber) ))
                
//                label.layer.borderColor = UIColor.blackColor().CGColor;
//                label.layer.borderWidth = 1.0;
                
                label.backgroundColor = differentColorValues[y] as! UIColor
                
                
             graphView.addSubview(label)
             xValue = xValue + label.frame.size.height
            
            }

            
        }
        
    }

}
