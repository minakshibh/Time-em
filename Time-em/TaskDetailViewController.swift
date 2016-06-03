//
//  TaskDetailViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 20/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import AVKit

class TaskDetailViewController: UIViewController ,UIScrollViewDelegate{

    var err: NSError? = nil
    var taskData:NSMutableDictionary! = [:]
    @IBOutlet var TextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var TextHeadingHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewVideo: UIImageView!
    @IBOutlet var btnPlayVideo: UIButton!
    @IBOutlet var lblTaskDate: UILabel!
    @IBOutlet var viewimageBackground: UIView!
    @IBOutlet var txtComments: UITextView!
    @IBOutlet var lblHourWorked: UILabel!
    @IBOutlet var txtTaskDescription: UITextView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    var videoStatus:Bool = false
    var videoData:NSData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        viewimageBackground.layer.cornerRadius = 4
        viewimageBackground.clipsToBounds = true

//        print(taskData)

    txtComments.scrollEnabled = false
        
    txtTaskDescription.text = taskData.valueForKey("TaskName") as? String
    txtComments.text = taskData.valueForKey("Comments") as? String
    lblHourWorked.text = taskData.valueForKey("TimeSpent")!  as? String
    print(taskData.valueForKey("CreatedDate")!)
        
        if taskData.valueForKey("TaskName") != nil {
        
        var dateStr = "\(taskData.valueForKey("CreatedDate")!)".componentsSeparatedByString(" ")[0]
        var dateArr = dateStr.componentsSeparatedByString("/") as? NSArray
        dateStr = "\(dateArr![2])-\(dateArr![1])-\(dateArr![0])T\("\(taskData.valueForKey("CreatedDate")!)".componentsSeparatedByString(" ")[1])"
        
        
                        let dateFormatter: NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        
                        let date: NSDate = dateFormatter.dateFromString(dateStr)!
                        // create date from string
                        // change to a readable time format and change to local time zone
                        dateFormatter.dateFormat = "EEE MMM d, yyyy"
        
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        let timestamp: String = dateFormatter.stringFromDate(date)
        lblTaskDate.text = "\(timestamp)"
        }else {
             lblTaskDate.text = "\(taskData.valueForKey("CreatedDate")!)"
        }
        
        
        
        
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(0, 2000)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 450, y: 2000)
        

       // image or video processing
        
        
        if taskData.valueForKey("AttachmentImageFile") != nil {
            
            if taskData.valueForKey("AttachmentImageFile") as? String != "" {
             
                let database = databaseFile()
                let dataArr:NSMutableArray!
                dataArr = database.getImageForUrl("\(taskData.valueForKey("AttachmentImageFile")!)",imageORvideo:"AttachmentImageFile")
                
                if dataArr.count > 0 {
                    if "\(dataArr[0])" != "" {
                        let data:NSData = dataArr[0] as! NSData
                        let userImageData:NSData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSData
                        self.imageView.image = UIImage(data: userImageData)
                        return
                    }
                }
                
                let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentImageFile")!)")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!)
                    dispatch_async(dispatch_get_main_queue(), {
                        if self.imageView != nil {
                       self.imageView.image = UIImage(data: data!)
                        }
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                        let database = databaseFile()
                        database.addImageToTask("\(self.taskData.valueForKey("AttachmentImageFile")!)", AttachmentImageData: encodedData, imageORvideo:"AttachmentImageFile")
                    });
                }
            }else{
              imageView.hidden = true
            }
            
        }else{
            imageView.hidden = true
        }
        
        if taskData.valueForKey("AttachmentVideoFile") != nil {
            
            if taskData.valueForKey("AttachmentVideoFile") as? String != "" {
                
                // check and get image from databse
                let database = databaseFile()
                let dataArr:NSMutableArray!
                dataArr = database.getImageForUrl("\(taskData.valueForKey("AttachmentVideoFile")!)",imageORvideo:"AttachmentVideoFile")
                if dataArr.count > 0 {
                    if "\(dataArr[0])" != "" {
                        let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentVideoFile")!)")
                        
                        generateThumbnail(url!)
                        
                        let data:NSData = dataArr[0] as! NSData
                        let userVideoData:NSData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSData
                        videoData = userVideoData
                        return
                    }
                }
                
                
                
//                downloadVideo  and save to databse
                
                let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentVideoFile")!)")
                self.generateThumbnail(url!)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    let data = NSData(contentsOfURL: url!)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //----
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                        let database = databaseFile()
                        database.addImageToTask("\(self.taskData.valueForKey("AttachmentVideoFile")!)", AttachmentImageData: encodedData,imageORvideo:"AttachmentVideoFile")
                        self.videoData = data!
                    });
                }
                
            }
        }
       
        
    }

    func generateThumbnail (url:NSURL) {
        do {
            let asset = AVURLAsset(URL: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            let uiImage = UIImage(CGImage: cgImage)
            viewimageBackground.hidden = false
            self.imageViewVideo.image = uiImage
            
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
    }
    
    func playVideo(data:NSData) {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let temppath:String = documentDirectory.stringByAppendingString("/video.mp4")
        videoStatus = data.writeToFile(temppath, atomically: true)
        
        if videoStatus {
            let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: temppath)))
            let playerItem = AVPlayerItem(asset:videoAsset)
            
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            presentViewController(playerViewController, animated:true){
                playerViewController.player!.play()
            }

        }
    }
    
    @IBAction func btnPlayVideo(sender: AnyObject) {
        playVideo(videoData)
    }
    override func viewDidDisappear(animated: Bool) {
        
        if videoStatus {
            let filemanager = NSFileManager.defaultManager()
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .   UserDomainMask, true)[0] as String
            let temppath:String = documentDirectory.stringByAppendingString("/video.mp4")
            do{
                try filemanager.removeItemAtPath(temppath)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if Reachability.DeviceType.IS_IPHONE_5 {
        scrollView.contentSize = CGSizeMake(320, 700)
        }
        
        let sizeThatFitsTextView: CGSize = self.txtComments.sizeThatFits(CGSizeMake(txtComments.frame.size.width, CGFloat(MAXFLOAT)))
        TextViewHeightConstraint.constant = sizeThatFitsTextView.height
        
        
        let sizeThatFitsTextView1: CGSize = self.txtTaskDescription.sizeThatFits(CGSizeMake(txtTaskDescription.frame.size.width, CGFloat(MAXFLOAT)))
        TextHeadingHeightConstraint.constant = sizeThatFitsTextView1.height

        

    }
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

}
