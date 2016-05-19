//
//  TaskData.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 18/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class TaskData: NSObject {

    
    var  ActivityId:Int!
    var  AttachmentImageFile:String! = ""
    var  AttachmentVideoFile:String = ""
    var  Comments:String! = ""
    var  CreatedDate:String! = ""
    var  EndTime:String! = ""
    var  Id: Int!
    var  SelectedDate:String! = ""
    var  SignedInHours: Int!
    var  StartTime:String! = ""
    var  TaskId:Int!
    var  TaskName :String! = ""
    var  TimeSpent:Float!
    var  Token: String! = ""
    var  UserId: Int!
    
    
    required init(ActivityId: Int?, AttachmentImageFile: String?, AttachmentVideoFile: String?, Comments: String?, CreatedDate: String?, EndTime: String?, Id: Int?, SelectedDate: String?, SignedInHours: Int?, StartTime: String?, TaskId: Int?, TaskName: String?, TimeSpent: Float?, Token: String?, UserId: Int?) {
        self.ActivityId = ActivityId!
        self.AttachmentImageFile = AttachmentImageFile ?? ""
        self.AttachmentVideoFile = AttachmentVideoFile ?? ""
        self.Comments = Comments ?? ""
        self.CreatedDate = CreatedDate!
        self.EndTime = EndTime ?? ""
        self.Id = Id!
        self.SelectedDate = SelectedDate ?? ""
        self.SignedInHours = SignedInHours!
        self.StartTime = StartTime ?? ""
        self.TaskId = TaskId!
        self.TaskName = TaskName ?? ""
        self.TimeSpent = TimeSpent!
        self.Token = Token ?? ""
        self.UserId = UserId!
    }

    convenience required init(dict: NSMutableDictionary) {
        self.init(ActivityId: dict["ActivityId"] as? Int,
                  AttachmentImageFile: dict["AttachmentImageFile"] as? String,
                  AttachmentVideoFile: dict["AttachmentVideoFile"] as? String,
                  Comments: dict["Comments"] as? String,
                  CreatedDate: dict["CreatedDate"] as? String,
                  EndTime: dict["EndTime"] as? String,
                  Id: dict["Id"] as? Int,
                  SelectedDate: dict["SelectedDate"] as? String,
                  SignedInHours: dict["SignedInHours"] as? Int,
                  StartTime: dict["StartTime"] as? String ,
                  TaskId: dict["TaskId"] as? Int,
                  TaskName: dict["TaskName"] as? String ,
                  TimeSpent: dict["TimeSpent"] as? Float ,
                  Token : dict["Token"] as? String,
                  UserId: dict["UserId"] as? Int
                  
                )
    }

    func returnDict() -> NSMutableDictionary {
        
        let data:NSMutableDictionary = [:]
        data.setObject(self.ActivityId, forKey: "ActivityId")
        data.setObject(self.AttachmentImageFile, forKey: "AttachmentImageFile")
        data.setObject(self.AttachmentVideoFile, forKey: "AttachmentVideoFile")
        data.setObject(self.Comments, forKey: "Comments")
        data.setObject(self.CreatedDate, forKey: "CreatedDate")
        data.setObject(self.EndTime, forKey: "EndTime")
        data.setObject(self.Id, forKey: "Id")
        data.setObject(self.SelectedDate, forKey: "SelectedDate")
        data.setObject(self.SignedInHours, forKey: "SignedInHours")
        data.setObject(self.StartTime, forKey: "StartTime")
        data.setObject(self.TaskId, forKey: "TaskId")
        data.setObject(self.TaskName, forKey: "TaskName")
        data.setObject(self.TimeSpent, forKey: "TimeSpent")
        data.setObject(self.Token, forKey: "Token")
        data.setObject(self.UserId, forKey: "UserId")
        return data
    }
    

}
