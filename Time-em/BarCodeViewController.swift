//
//  BarCodeViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 25/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift


class BarCodeViewController: RSCodeReaderViewController {

    @IBOutlet var btnback: UIButton!
    @IBOutlet var lblHeader: UILabel!
    
    var barCodeValue:String!
    var scanedBarCodes:NSMutableArray = []
    
    
    @IBOutlet var toggle: UIButton!
    
    @IBAction func close(sender: AnyObject?) {
        print("close called.")
    }
    
    @IBAction func toggle(sender: AnyObject?) {
        let isTorchOn = self.toggleTorch()
        print(isTorchOn)
    }
    
    var barcode: String = ""
    var dispatched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.performSegueWithIdentifier("barcodeDetail", sender: self)
        
        
        

        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        
        self.tapHandler = { point in
            print(point)
        }
        
       
        let types = NSMutableArray(array: self.output.availableMetadataObjectTypes)
        types.removeObject(AVMetadataObjectTypeQRCode)
        self.output.metadataObjectTypes = NSArray(array: types) as [AnyObject]
        
        // MARK: NOTE: If you layout views in storyboard, you should these 3 lines
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview)
        }
         self.view.bringSubviewToFront(btnback)
//        if !self.hasTorch() {
//            self.toggle.enabled = false
//        }
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    self.barcode = barcode.stringValue
                    print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                    self.scanedBarCodes.addObject(barcode.stringValue)
                    
                    let alert=UIAlertController(title: "Success", message: "Barcode scanned successfully. Do you want to scan another barcode.", preferredStyle: UIAlertControllerStyle.Alert);
                    //default input textField (no configuration...)
                    //no event handler (just close dialog box)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                        print(self.scanedBarCodes)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.performSegueWithIdentifier("barcodeDetail", sender: self)
                            
                            // MARK: NOTE: Perform UI related actions here.
                        })
                    }));
                    //event handler with closure
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                        self.dispatched = false
                    }));
                    self.presentViewController(alert, animated: true, completion: nil);
                    
                    
                    
                    
                }
            }
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
       
    }
    
    override func viewWillAppear(animated: Bool) {
        self.dispatched = false // reset the flag so user can do another scan
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        
        
        
        let btnback   = UIButton(type: UIButtonType.System) as UIButton
        btnback.frame = CGRectMake(0, lblHeader.frame.origin.y, 25, lblHeader.frame.size.height)
        btnback.backgroundColor = UIColor.clearColor()
//        btnback.setImage(UIImage(named: "previous-icon"), forState: .Normal)
        btnback.addTarget(self, action: #selector(BarCodeViewController.btnbackCopy(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(btnback)
    }
    func btnbackCopy(sender:UIButton!)
    {
          self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
        
        if segue.identifier == "barcodeDetail" {
            let destinationVC = segue.destinationViewController as! BarcodeDetailViewController
            destinationVC.scannedBarcodeArr = scanedBarCodes
        }
    }
       
    
    
}
