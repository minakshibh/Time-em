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
    
    
    var bottomSpace:CGFloat = 20.0
    var leftSpace:CGFloat = 20.0
    var boundryLinesWidth:CGFloat = 2.0
    var viewHeight:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        graph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func graph(){
        
         scrollView = UIScrollView(frame: CGRectMake(bottomSpace, leftSpace, self.view.frame.size.width-bottomSpace, self.view.frame.size.height-leftSpace))
        scrollView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(scrollView)
        
        graphBoundryLeft = UILabel(frame: CGRectMake(0, 20, boundryLinesWidth, scrollView.frame.size.height))
        graphBoundryLeft.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(graphBoundryLeft)
        
        graphBoundryTop = UILabel(frame: CGRectMake(0, 20, scrollView.frame.size.width, boundryLinesWidth))
        graphBoundryTop.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(graphBoundryTop)
        
        var xViewValue:CGFloat = 0.0
        for(var x=0;x<5;x+=1){
           
            let graphView = UIView(frame: CGRectMake(10*CGFloat(x) + xViewValue, 20, viewHeight, scrollView.frame.size.height))
            graphView.backgroundColor = UIColor.darkGrayColor()
            self.scrollView.addSubview(graphView)
            xViewValue = xViewValue + viewHeight
        }
//            var xValue:CGFloat = 0.0
//            var yValue:CGFloat = 0.0
//            for(var y=0;y<5;y+=1){
//            let label = UILabel(frame: CGRectMake(0, 0 + xValue, viewHeight, 20))
//                label.backgroundColor = UIColor.yellowColor()
//                label.layer.borderColor = UIColor.blackColor().CGColor
//                graphView.addSubview(label)
//                xValue = xValue + label.frame.size.height
//                
//            }
//            xViewValue = xViewValue + viewHeight
//        }
        
    }

}
