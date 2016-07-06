//
//  SeetingViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 14/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class SeetingViewController: UIViewController {

    @IBOutlet var lblbuildVersion: UILabel!
    @IBOutlet var lblBuildSize: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var buildVersion:String = ""
        var int:Int = 0
        if let text = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
           buildVersion = "\(text)"
            int = text.characters.count
        }
        
        lblbuildVersion.text = buildVersion
        
        do{
        // Go through the app's bundle
        let bundlePath = NSBundle.mainBundle().bundlePath
        let bundleArray:NSArray = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(bundlePath)
        let bundleEnumerator = bundleArray.objectEnumerator()
        var fileSize: UInt64 = 0
        
        while let fileName:String = bundleEnumerator.nextObject() as? String {
            let fileDictionary:NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath((bundlePath as NSString).stringByAppendingPathComponent(fileName))
            fileSize += fileDictionary.fileSize();
        }
        
        
        
        // Go through the app's document directory
        let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath:NSString = documentDirectory[0] as! NSString
        let documentDirectoryArray:NSArray = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(documentDirectoryPath as String)
        let documentDirectoryEnumerator = documentDirectoryArray.objectEnumerator()
        
        while let file:String = documentDirectoryEnumerator.nextObject() as? String {
            let attributes:NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(documentDirectoryPath.stringByAppendingPathComponent(file))
            fileSize += attributes.fileSize();
        }
        
        // Go through the app's library directory
        let libraryDirectory:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let libraryDirectoryPath:NSString = libraryDirectory[0] as! NSString
        let libraryDirectoryArray:NSArray = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(libraryDirectoryPath as String)
        let libraryDirectoryEnumerator = libraryDirectoryArray.objectEnumerator()
        
        while let file:String = libraryDirectoryEnumerator.nextObject() as? String {
            let attributes:NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(libraryDirectoryPath.stringByAppendingPathComponent(file))
            fileSize += attributes.fileSize();
        }
        
        // Go through the app's tmp directory
        let tmpDirectoryPath:NSString = NSTemporaryDirectory()
        let tmpDirectoryArray:NSArray = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(tmpDirectoryPath as String)
        let tmpDirectoryEnumerator = tmpDirectoryArray.objectEnumerator()
        
        while let file:String = tmpDirectoryEnumerator.nextObject() as? String {
            let attributes:NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(tmpDirectoryPath.stringByAppendingPathComponent(file))
            fileSize += attributes.fileSize();
        }
        
        let fileSystemSizeInMegaBytes : Double = Double(fileSize)/1000000
        print("Total App Space: \(fileSystemSizeInMegaBytes) MB")
            lblBuildSize.text = "\(roundToPlaces(fileSystemSizeInMegaBytes, places: 2)) MB"
        }catch {
            
        }
    }

    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
