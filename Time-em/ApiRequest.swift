//
//  ApiRequest.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 11/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import FMDB
import Toast_Swift

public class ApiRequest {
    
    func loginApi(loginId:String,password:String,view:UIView) {
        let notificationKey = "com.time-em.loginResponse"
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
           return
        }
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/User/GetValidateUser", parameters: ["loginId":loginId,"password":password])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
        if "\(response.result)" == "SUCCESS"{
            let userInfo = ["response" : "SUCCESS"]
           
            if let field = JSON.valueForKey("Message")   as? String{
                if "\(JSON.valueForKey("Message")!)".lowercaseString == "an error has occurred." {
                    let userInfo = ["response" : "failre"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                    MBProgressHUD.hideHUDForView(view, animated: true)
                    return
                }
            }
            
            
            
            let currentUsers =  User(dict: JSON as! NSMutableDictionary)
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Id)", forKey: "currentUser_id")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.IsSignIn)", forKey: "currentUser_IsSignIn")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.ActivityId)", forKey: "currentUser_ActivityId")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.LoginId)", forKey: "currentUser_LoginId")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.FullName)", forKey: "currentUser_FullName")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.UserTypeId)", forKey: "UserTypeId")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Email)", forKey: "currentUser_Email")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.PhoneNumber)", forKey: "currentUser_PhoneNumber")
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "forGraph")

            var dictionary:NSMutableDictionary = [:]
            dictionary = currentUsers.returnDict()
            
            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(dictionary)

            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")

            let database = FMDatabase(path: fileURL.path)
            
            if !database.open() {
                print("Unable to open database")
                return
            }
            
            do {
                try database.executeUpdate("create table tasksData(ActivityId text, AttachmentImageFile text, AttachmentVideoFile text ,Comments text, CreatedDate text, EndTime text,Id text, SelectedDate text, SignedInHours text,StartTime text, TaskId text, TaskName text,TimeSpent text, Token text, UserId text, AttachmentImageData text,isVideoRecorded text, isoffline text, uniqueno text)", values: nil)
                } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
                }
            
                do {
                try database.executeUpdate("create table teamData(ActivityId text, Company text, CompanyId text ,Department text, DepartmentId text, FirstName text,FullName text, Id text, IsNightShift text,IsSecurityPin text, IsSignedIn text, LastName text,LoginCode text, LoginId text, NFCTagId text, Project text ,ProjectId text, SignInAt text, SignOutAt text,SignedInHours text, SupervisorId text, TaskActivityId text,UserTypeId text, Worksite text, WorksiteId text)", values: nil)
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
            
            do {
                try database.executeUpdate("create table userdata(userId text, userData text, loggedInUser text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table notificationtype(data text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table notificationActiveUserList(userid text,FullName text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table notificationsTable(AttachmentFullPath text,Message text,NotificationId text,NotificationTypeName text,SenderFullName text,Senderid text,Subject text,createdDate text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table sync(type text, data text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table assignedTaskList(TaskId text, TaskName text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            
            do {
                try database.executeUpdate("create table TasksList(timespent text, date text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            
            do {
                try database.executeUpdate("create table UserSignedList(signedout text,signedin text, date text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            
            do {
                try database.executeUpdate("insert into UserData (userId, userData, loggedInUser) values (?, ?, ?)", values: [currentUsers.LoginId, encodedData, "true"])
               
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }

            database.close()
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "userLoggedIn")
            
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            
            
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
                }else{
                    let userInfo = ["response" : "FAILURE"]
                    main{
                        MBProgressHUD.hideHUDForView(view, animated: true)
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                   
                }
        }
        
    }
    
    func deleteTasks(Id:String,TimeSpent:String,CreatedDate:String,isoffline:String,TaskId:String,view:UIView) {
        let notificationKey = "com.time-em.deleteResponse"
        
        //--
        if isoffline == "true"{
            let database = databaseFile()
            database.deleteTask(Id, TimeSpent: TimeSpent, CreatedDate: CreatedDate, isoffline: isoffline, TaskId:TaskId)
            view.makeToast("task deleted successfully")
            let userInfo = ["response" : "success"]
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
        }
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED. Request saved in sync")
            
            let array:NSMutableArray = []
            array.addObject(Id)
//            array.addObject(view)
            
            let database = databaseFile()
            
            
            if isoffline != "true"{
                database.addDataToSync("deleteTasks", data: array)
                NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
            }
            database.deleteTask(Id, TimeSpent: TimeSpent, CreatedDate: CreatedDate, isoffline: isoffline, TaskId:TaskId)
            
            let userInfo = ["response" : "success"]
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
            
        }
        
        //--
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/UserTask/DeleteTask", parameters: ["Id":Id])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        let userInfo = ["response" : "SUCCESS"]
                        
                        if "\(JSON.valueForKey("isError")!)" == "0"{
                            
                            var databse = databaseFile()
                            databse.deleteTask(Id, TimeSpent: TimeSpent, CreatedDate: CreatedDate, isoffline: isoffline, TaskId:TaskId)
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    // http://timeemapi.azurewebsites.net/api/User/GetValidateUserByPin?loginId=admin&SecurityPin
    func loginThroughPasscode(loginId:String,SecurityPin:String,view:UIView) {
        let notificationKey = "com.time-em.passcodeloginResponse"
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/User/GetValidateUserByPin", parameters: ["loginId":loginId,"SecurityPin":SecurityPin])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        let userInfo = ["response" : "SUCCESS"]
                        
                        if "\(JSON.valueForKey("isError")!)" != "0" {
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            
                            return
                        }
                        
                        let currentUsers =  User(dict: JSON as! NSMutableDictionary)
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Id)", forKey: "currentUser_id")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.IsSignIn)", forKey: "currentUser_IsSignIn")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.ActivityId)", forKey: "currentUser_ActivityId")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.LoginId)", forKey: "currentUser_LoginId")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.FullName)", forKey: "currentUser_FullName")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.UserTypeId)", forKey: "UserTypeId")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Email)", forKey: "currentUser_Email")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.PhoneNumber)", forKey: "currentUser_PhoneNumber")
                        NSUserDefaults.standardUserDefaults().setObject("no", forKey: "forGraph")
                        
                        var dictionary:NSMutableDictionary = [:]
                        dictionary = currentUsers.returnDict()
                        
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
                        
                        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                        
                        let database = FMDatabase(path: fileURL.path)
                        
                        if !database.open() {
                            print("Unable to open database")
                            return
                        }
                        
                        do {
                            try database.executeUpdate("UPDATE UserData SET userData = ? , loggedInUser = ? WHERE userId=?", values: [encodedData,"true",currentUsers.LoginId])
                            
                        } catch let error as NSError {
                            print("failed: \(error.localizedDescription)")
                        }
                        
                        database.close()
                        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "userLoggedIn")
                        
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    
    func getUserTask(userId:String,createdDate:String,TimeStamp:String,view:UIView) {
        
        let notificationKey = "com.time-em.usertaskResponse"
        
        let status:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("isEditingOrAdding")!)"
        if status.lowercaseString == "true" {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey:"isEditingOrAdding")
            MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
        
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/UserTask/GetUserActivityTask", parameters: ["userId":userId,"createdDate":createdDate, "TimeStamp":TimeStamp])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    var message:String!
                    if JSON.valueForKey("IsError") != nil {
                        message = "\(JSON.valueForKey("IsError")!)"
                    }else{
                        let userInfo = ["response" : "Failure"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        return
                    }
                    
                    
                    if message!.lowercaseString == "0"{
                        
                        //                        var dictTime:NSMutableDictionary = [:]
                        //                        let user = NSUserDefaults.standardUserDefaults()
                        //                        if user.valueForKey("dashboardNotificationTimeStamp") != nil{
                        //                            let data = user.objectForKey("dashboardNotificationTimeStamp") as? NSData
                        //                            var dict:NSMutableDictionary = (NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? NSMutableDictionary)!
                        //                            dictTime = dict
                        //                            if dict.valueForKey("")
                        //                        }
                        let dict:NSArray = JSON.valueForKey("UserTaskActivityViewModel") as! NSArray
                        
                        
                        
                        
                        if dict.count > 0 {
                            //---------
                            var saveDateDict:NSMutableDictionary = [:]
                            let user: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            if user.valueForKey("taskTimeStamp") != nil {
                                let data: NSData = (user.valueForKey("taskTimeStamp")! as! NSData)
                                let dictio = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
                                saveDateDict = dictio
                                if (saveDateDict.valueForKey("\(dict[0].valueForKey("UserId")!)") != nil) {
                                    
                                    saveDateDict.removeObjectForKey("\(dict[0].valueForKey("UserId")!)")
                                    
                                    saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "\(dict[0].valueForKey("UserId")!)")
                                }
                                else {
                                    
                                    saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "\(dict[0].valueForKey("UserId")!)")
                                }
                            }
                            else {
                                saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "\(dict[0].valueForKey("UserId")!)")
                                
                            }
                            let data1: NSData = NSKeyedArchiver.archivedDataWithRootObject(saveDateDict)
                            user.setObject(data1,forKey:"taskTimeStamp")
                            //-------------
                        }
                        
                        
                        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                        
                        let database = FMDatabase(path: fileURL.path)
                        
                        if !database.open() {
                            print("Unable to open database")
                            return
                        }
                        
                        // get already added tasks taskids
                        var TaskIdsArr:NSMutableArray = []
                        do {
                            
                            let rs = try database.executeQuery("select * from tasksData", values: nil)
                            while rs.next() {
                                let x = rs.stringForColumn("Id")
                                TaskIdsArr.addObject(x)
                            }
                        } catch let error as NSError {
                            print("failed: \(error.localizedDescription)")
                        }
                        
                        
                        
                        
                        for (var i = 0; i<dict.count;i+=1){
                            
                            let  ActivityId:Int!
                            if let field = dict[i].valueForKey("ActivityId")   {
                                ActivityId = field as! Int
                            }else{
                                ActivityId = 0
                            }
                            
                            let  AttachmentImageFile:String!
                            if let field = dict[i].valueForKey("AttachmentImageFile")  as? String{
                                AttachmentImageFile = field
                            }else{
                                AttachmentImageFile = ""
                            }
                            
                            let  AttachmentVideoFile:String
                            if let field = dict[i].valueForKey("AttachmentVideoFile") as? String {
                                AttachmentVideoFile = field
                            }else{
                                AttachmentVideoFile = ""
                            }
                            
                            let  Comments:String!
                            if let field = dict[i].valueForKey("Comments") as? String {
                                Comments = field
                            }else{
                                Comments = ""
                            }
                            
                            let  CreatedDate:String!
                            if let field = dict[i].valueForKey("CreatedDate") as? String {
                                CreatedDate = field
                            }else{
                                CreatedDate = ""
                            }
                            
                            let  EndTime:String!
                            if let field = dict[i].valueForKey("EndTime") as? String {
                                EndTime = field
                            }else{
                                EndTime = ""
                            }
                            
                            let  Id: Int!
                            if let field = dict[i].valueForKey("Id")  {
                                Id = field as! Int
                            }else{
                                Id = 0
                            }
                            
                            let  SelectedDate:String!
                            if let field = dict[i].valueForKey("SelectedDate")   as? String{
                                SelectedDate = field
                            }else{
                                SelectedDate = ""
                            }
                            
                            let  SignedInHours: Int!
                            if let field = dict[i].valueForKey("SignedInHours")  {
                                SignedInHours = field as! Int
                            }else{
                                SignedInHours = 0
                            }
                            
                            let  StartTime:String!
                            if let field = dict[i].valueForKey("StartTime") as? String  {
                                StartTime = field
                            }else{
                                StartTime = ""
                            }
                            
                            let  TaskId:Int!
                            if let field = dict[i].valueForKey("TaskId")  {
                                TaskId = field as! Int
                            }else{
                                TaskId = 0
                            }
                            
                            
                            let  TaskName :String!
                            if let field = dict[i].valueForKey("TaskName") as? String {
                                TaskName = field
                            }else{
                                TaskName = ""
                            }
                            
                            let  TimeSpent:Float!
                            if let field = dict[i].valueForKey("TimeSpent")  {
                                TimeSpent = field as! Float
                            }else{
                                TimeSpent = 0
                            }
                            
                            
                            let  Token: String!
                            if let field = dict[i].valueForKey("Token") as? String {
                                Token = field
                            }else{
                                Token = ""
                            }
                            
                            
                            let  UserId: Int!
                            if let field = dict[i].valueForKey("UserId")  {
                                UserId = field as! Int
                            }else{
                                UserId = 0
                            }
                            
                            let  isActive: Int!
                            if let field = dict[i].valueForKey("isActive")  {
                                isActive = field as! Int
                            }else{
                                isActive = 0
                            }
                            
                            
                            
                            
                            if TaskIdsArr.containsObject("\(Id!)") {
                                if isActive == 0 {
                                    let databse = databaseFile()
                                    databse.deleteTaskFromDatabse("\(TaskId!)")
                                    continue
                                }
                                do {
                                    try database.executeUpdate("UPDATE tasksData SET ActivityId = ? , AttachmentImageFile = ? , AttachmentVideoFile = ?  ,Comments = ? , CreatedDate = ? , EndTime  = ?, SelectedDate  = ?, SignedInHours = ?,StartTime = ? , TaskId = ? , TaskName = ? ,TimeSpent = ? , Token = ? , UserId = ? WHERE Id=?", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId , Id])
                                } catch let error as NSError {
                                    print("failed: \(error.localizedDescription)")
                                }
                                
                            }else{
                                if isActive == 0 {
                                    continue
                                }
                                
                                do {
                                    //                    try database.executeUpdate("delete * from  tasksData", values: nil)
                                    try database.executeUpdate("insert into tasksData (ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId, AttachmentImageData,uniqueno ) values (?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?, ?,?)", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId ,"", "" ])
                                    
                                } catch let error as NSError {
                                    print("failed: \(error.localizedDescription)")
                                }
                            }
                            
                        }
                        database.close()
                        
                        let userInfo = ["response" : "SUCCESS"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
                        
                        
                        
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    
    func signOutUser(userId:String,LoginId:String,ActivityId:String,view:UIView)  {
        let notificationKey = "com.time-em.signInOutResponse"
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED.")
//            let array:NSMutableArray = []
//            array.addObject(userId)
//            array.addObject(LoginId)
//            array.addObject(ActivityId)
//            array.addObject(view)
//            
//            let database = databaseFile()
//            database.addDataToSync("signOutUser", data: array)
//            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
//            
//            NSUserDefaults.standardUserDefaults().setObject("0", forKey: "currentUser_IsSignIn")
//            database.currentUserSignOutSync()
//            
//            let userInfo = ["response" : "Sign out successfully"]
//            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
        }
        
        
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/UserActivity/SignOutByUserId", parameters: ["Userids":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        
                        if "\(JSON.valueForKey("isError")!)" == "0" {
                            
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("user already signed out.") != nil{
                                let database = databaseFile()
                                NSUserDefaults.standardUserDefaults().setObject("0", forKey: "currentUser_IsSignIn")
                                database.currentUserSignOutSync()
                                let userInfo = ["response" : "\(JSON.valueForKey("successfull")!)"]
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                MBProgressHUD.hideHUDForView(view, animated: true)

                                return
                            }
                            
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSUserDefaults.standardUserDefaults().setObject("\(0)", forKey: "currentUser_IsSignIn")
                            
                            
                            let array = JSON.valueForKey("SignedOutUser") as? NSArray
                            
                            let database = databaseFile()
                            database.currentUserSignOut(array!)
                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                            
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    func signInUser(userId:String,LoginId:String,view:UIView)  {
        let notificationKey = "com.time-em.signInOutResponse"
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED.")
//
//            let array:NSMutableArray = []
//            array.addObject(userId)
//            array.addObject(LoginId)
//            array.addObject(view)
//            
//            let database = databaseFile()
//            database.addDataToSync("signInUser", data: array)
//            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
//            
//            
//            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "currentUser_IsSignIn")
//            database.currentUserSignInSync()
//            let userInfo = ["response" : "Sign in successfully"]
//            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net//api/UserActivity/SignInByUserId", parameters: ["Userids":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("isError")!)" == "0" {
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("user already signed in.") != nil{
                                 let database = databaseFile()
                                database.currentUserSignInSync()
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                MBProgressHUD.hideHUDForView(view, animated: true)
                                return
                            }
                            NSUserDefaults.standardUserDefaults().setObject("\(1)", forKey: "currentUser_IsSignIn")
                            let arr = JSON.valueForKey("SignedinUser") as? NSArray
                            
                            let database = databaseFile()
                            database.currentUserSignIn(arr!)
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    
    
    func getTeamDetail(userId:String,TimeStamp:String,view:UIView)  {
        let notificationKey = "com.time-em.getTeamResponse"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/User/GetAllUsersList", parameters: ["userId":userId,"TimeStamp":TimeStamp])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)

                            return
                        }
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSUserDefaults.standardUserDefaults().setObject(JSON.valueForKey("TimeStamp"), forKey: "teamTimeStamp")
                            let dict = JSON.valueForKey("AppUserViewModel") as! NSArray
                            
                            let database = databaseFile()
                            database.insertTeamData(dict)
                            
                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    
    func fetchUserTaskGraphDataFromAPI(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.getUserTaskGraphData"
        
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/usertask/UserTaskGraph", parameters: ["userId":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            return
                        }
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            let dict = JSON.valueForKey("TasksList") as! NSArray
                            
                            let database = databaseFile()
                            database.insertUserTaskGraphData(dict)
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    
    func fetchUserSignedGraphDataFromAPI(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.getUserSignedGraphData"
        
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/usertask/UsersGraph", parameters: ["userId":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            return
                        }
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            let dict = JSON.valueForKey("UsersList") as! NSArray
                            
                            let database = databaseFile()
                            database.insertUserSignedGraphData(dict)
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
            MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    
    
    func GetAssignedTaskIList(userId:String,view:UIView)  {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/Task/GetAssignedTaskIList", parameters: ["userId":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
//                            let userInfo = ["response" : "FAILURE"]
//                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            return
                        }
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
//                            let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
                            
                            let dict = JSON.valueForKey("ReturnKeyValueViewModel") as! NSArray
                            
                            let database = databaseFile()
                            database.insertAssignedListData(dict)
                            
                            
                           
                            
                        }else{
//                            let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
//                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
//                        let userInfo = ["response" : "FAILURE"]
//                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
//                    let userInfo = ["response" : "FAILURE"]
//                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    func AddUpdateNewTask(imageData: NSData, videoData: NSData, ActivityId: String, TaskId: String, UserId: String, TaskName: String, TimeSpent: String, Comments: String, CreatedDate: String, ID:String, view:UIView, isVideoRecorded:Bool,isoffline:String,uniqueno:String)
    {
        let notificationKey = "com.time-em.addTaskResponse"
        //--
        if isoffline == "true" && ID == "0" {
            
            let issignedin:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)"
            if issignedin == "0" {
               
                let userInfo = ["response" : "Signin before editing task."]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                return
            }
            
            
           let database = databaseFile()
            
            database.addTaskSync(imageData, videoData: videoData, ActivityId: ActivityId, TaskId: TaskId, UserId: UserId, TaskName: TaskName, TimeSpent: TimeSpent, Comments: Comments, CreatedDate: CreatedDate, ID: ID, isVideoRecorded: "\(isVideoRecorded)",uniqueno:uniqueno)
            let userInfo = ["response" : "success"]
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            
            return
        }
        
        
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            let issignedin:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)"
            if issignedin == "0" {
                
                let userInfo = ["response" : "Signin before adding task."]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                return
            }
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED. Request saved in sync")
            let uniqueno:String = "\(UserId)\(currentTimeMillis())"
            
            let array:NSMutableArray = []
            array.addObject(imageData)
            array.addObject(videoData)
            array.addObject(ActivityId)
            array.addObject(TaskId)
            array.addObject(UserId)
            array.addObject(TaskName)
            array.addObject(TimeSpent)
            array.addObject(Comments)
            array.addObject(CreatedDate)
            array.addObject(ID)
            array.addObject(isVideoRecorded)
            array.addObject(uniqueno)
            let database = databaseFile()
            database.addDataToSync("AddUpdateNewTask", data: array)
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
            //
            
            database.addTaskSync(imageData, videoData: videoData, ActivityId: ActivityId, TaskId: TaskId, UserId: UserId, TaskName: TaskName, TimeSpent: TimeSpent, Comments: Comments, CreatedDate: CreatedDate, ID: ID, isVideoRecorded: "\(isVideoRecorded)",uniqueno:uniqueno)
            let userInfo = ["response" : "success"]
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            
            return
        }

        //--
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        let param = [
            "ActivityId"    :ActivityId,
            "TaskId"        :TaskId,
            "UserId"        :UserId,
            "TaskName"      :TaskName,
            "TimeSpent"     :TimeSpent,
            "Comments"      :Comments,
            "CreatedDate"   :CreatedDate,
            "ID"            :ID
        ]
                print(param)
        let url = NSURL(string: "http://timeemapi.azurewebsites.net/api/UserTask/AddUpdateUserTaskActivity")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let image = UIImage(data: imageData)
        
        let body = NSMutableData()
        
        for (key, value) in param {
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(value)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        if(image != nil)
        {
            let fname = "test.png"
            let mimetype = "image/png"
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        if isVideoRecorded {
            let fname = "testVideo.mp4"
            let mimetype = "video/.mp4"
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(videoData)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                let userInfo = ["response" : "Failed to add task. Kindly try again."]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                delay(0.001){
                    MBProgressHUD.hideHUDForView(view, animated: true)
                }
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print(dataString)
            
            if isoffline == "true"{
             let database = databaseFile()
                database.deleteTaskFromDatabse(TaskId)
            }
            
            delay(0.001){
                MBProgressHUD.hideHUDForView(view, animated: true)
                if "\(dataString!.lowercaseString)".rangeOfString("activity id does not exist") != nil{
                    let userInfo = ["response" : "please signin before adding task"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    return
                }
                let userInfo = ["response" : "SUCCESS"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            }
        }
        
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func sendNotification(imageData: NSData, UserId: String, Subject: String, Message: String, NotificationTypeId: String, notifyto: String, view:UIView)
    {
        let notificationKey = "com.time-em.sendnotification"
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED. Request saved in sync")

            let array:NSMutableArray = []
            array.addObject(imageData)
            array.addObject(UserId)
            array.addObject(Subject)
            array.addObject(Message)
            array.addObject(NotificationTypeId)
            array.addObject(notifyto)
//            array.addObject(view)
            
            let database = databaseFile()
            database.addDataToSync("sendNotification", data: array)
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
            
            let userInfo = ["response" : "success"]
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        let param = [
            "UserId"                   :UserId,
            "Subject"                   :Subject,
            "Message"                   :Message,
            "NotificationTypeId"       :NotificationTypeId,
            "notifyto"                  :notifyto
        ]
        //        print(param)
        let url = NSURL(string: "http://timeemapi.azurewebsites.net/api/Notification/AddNotification")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let image = UIImage(data: imageData)
        
        let body = NSMutableData()
        
        for (key, value) in param {
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(value)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        if(image != nil)
        {
            let fname = "test.png"
            let mimetype = "image/png"
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error in sending notification")
                print(response)
                  // original URL request
                let msg = "failed"
                let userInfo = ["response" : "\(msg)"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                delay(0.00) {
                MBProgressHUD.hideHUDForView(view, animated: true)
                }
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print(dataString)
            delay(0.001){
                MBProgressHUD.hideHUDForView(view, animated: true)
                if "\(dataString!.lowercaseString)".rangeOfString("an error occured") != nil{
                    let userInfo = ["response" : "faild to post notification"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                }
                let msg = "successfully"
                let userInfo = ["response" : "\(msg)"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            }
        }
        
        task.resume()
    }
    
    
    func resetPasswordApi(emailId:String,view:UIView)  {
        let notificationKey = "com.time-em.resetPassword"
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/USER/ForgetPassword", parameters: ["email":emailId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        let userInfo = ["response" : "SUCCESS"]
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    
    func resetPinApi(emailId:String,view:UIView)  {
        let notificationKey = "com.time-em.resetPin"
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/USER/ForgetPin", parameters: ["email":emailId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        let userInfo = ["response" : "SUCCESS"]
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    
    func teamUserSignIn(userId:String,LoginId:String,view:UIView)  {
        let notificationKey = "com.time-teamUserSignInOutResponse"
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED.")

//            let array:NSMutableArray = []
//            array.addObject(userId)
//            array.addObject(LoginId)
//            array.addObject(view)
//            
//            let database = databaseFile()
//            database.addDataToSync("teamUserSignIn", data: array)
//            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
//            
//            database.teamSignInUpdate(userId)
//             let userInfo = ["response" : "successfull"]
//            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net//api/UserActivity/SignInByUserId", parameters: ["Userids":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("isError")!)" == "0"{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("user already signed in.") != nil{
                                let database = databaseFile()
                                database.teamSignInUpdate(userId)
                                
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                MBProgressHUD.hideHUDForView(view, animated: true)
                                return
                            }
                            
                            
                            
                            
                            
                            let arr = JSON.valueForKey("SignedinUser") as? NSArray
                            
                            
                            
                            let val:NSDictionary = (arr![0] as? NSDictionary)!
                            
                            
                            
                            let database = databaseFile()
                            database.updateActivityIdForTeam(userId, activityId: "\(val.valueForKey("Id")!)",SignInAt:"\(val.valueForKey("SignInAt")!)")
                            //                            database.teamSignInUpdate(userId)
                            
                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            if "\(JSON.valueForKey("Message")!)".lowercaseString == "user is already signedin!" {
                                let arr = JSON.valueForKey("SignedinUser") as? NSArray
                                let val:NSDictionary = (arr![0] as? NSDictionary)!
                                
                                let database = databaseFile()
                                database.updateActivityIdForTeam(userId, activityId: "\(val.valueForKey("Id")!)",SignInAt:"\(val.valueForKey("SignInAt")!)")
                                //update query
                            }
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    func teamUserSignOut(userId:String,LoginId:String,ActivityId:String,view:UIView)  {
        let notificationKey = "com.time-teamUserSignInOutResponse"
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED.")

//            let array:NSMutableArray = []
//            array.addObject(userId)
//            array.addObject(LoginId)
//            array.addObject(ActivityId)
//            array.addObject(view)
//            
//            let database = databaseFile()
//            database.addDataToSync("teamUserSignOut", data: array)
//            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
//            
//            database.teamSignOutbyId(userId)
//            let userInfo = ["response" : "successfull"]
//            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
        }
        
        
        
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/UserActivity/SignOutByUserId", parameters: ["Userids":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        if "\(JSON.valueForKey("isError")!)" ==  "0" {
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            let arr = JSON.valueForKey("SignedOutUser") as? NSArray
                            let val:NSDictionary = (arr![0] as? NSDictionary)!
                            
                            let databse = databaseFile()
                            databse.teamSignOutUpdate(userId,SignInAt:"\(val.valueForKey("SignInAt")!)",SignOutAt:"\(val.valueForKey("SignOutAt")!)")
                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }else{
                            if "\(JSON.valueForKey("Message")!)".lowercaseString ==  "user already signed out.please signin!" {
                                let arr = JSON.valueForKey("SignedOutUser") as? NSArray
                                let val:NSDictionary = (arr![0] as? NSDictionary)!
                                
                                let databse = databaseFile()
                                databse.teamSignOutUpdate(userId,SignInAt:"\(val.valueForKey("SignInAt")!)",SignOutAt:"\(val.valueForKey("SignOutAt")!)")
                                
                            }
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    func teamSignInAll(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.signInOutAllResponse"
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED.")

//            let array:NSMutableArray = []
//            array.addObject(userId)
//            array.addObject(view)
//            
//            let database = databaseFile()
//            database.addDataToSync("teamSignInAll", data: array)
//            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
            return
        }
        
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net//api/UserActivity/SignInByUserId", parameters: ["Userids":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("isError")!)" == "0" {
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("user already signed in.") != nil{
                                
                                
                                let idArray = userId.componentsSeparatedByString(",")
                                let database = databaseFile()
                                for k in idArray {
                                    database.teamSignInUpdate(k)
                                }
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                MBProgressHUD.hideHUDForView(view, animated: true)
                                return
                            }
                            
                            
                            
                            let arr = JSON.valueForKey("SignedinUser") as? NSArray
                            let val:NSDictionary = (arr![0] as? NSDictionary)!
                            
                            let database = databaseFile()
                            
                            for i in arr! {
                                database.updateActivityIdForTeam("\(i.valueForKey("UserId")!)", activityId: "\(i.valueForKey("Id")!)", SignInAt: "\(i.valueForKey("SignInAt")!)")
                            }
                            
                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    func teamSignOutAll(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.signInOutAllResponse"
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            view.makeToast("Internet connection FAILED.")

//            let array:NSMutableArray = []
//            array.addObject(userId)
//            array.addObject(view)
//            
//            let database = databaseFile()
//            database.addDataToSync("teamSignOutAll", data: array)
//            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
            return
        }
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net//api/UserActivity/SignOutByUserId", parameters: ["Userids":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("isError")!)" == "0" {
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("user already signed out.") != nil{
                                
                                
                                let idArray = userId.componentsSeparatedByString(",")
                                let database = databaseFile()
                                for k in idArray {
                                    database.signOutUpdate(k)
                                }
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                MBProgressHUD.hideHUDForView(view, animated: true)
                                return
                            }
                            
                            
                            
                            
                            let arr = JSON.valueForKey("SignedOutUser") as? NSArray
                            let val:NSDictionary = (arr![0] as? NSDictionary)!
                            
                            let database = databaseFile()
                            
                            for i in arr! {
                                
                                
                                database.teamSignOutUpdate("\(i.valueForKey("UserId")!)", SignInAt: "\(i.valueForKey("SignInAt")!)", SignOutAt: "\(i.valueForKey("SignOutAt")!)")
                            }
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    func openDatabase()  {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
    }
    
    func GetNotificationType() {
        let notificationKey = "com.time-em.NotificationTypeloginResponse"
        
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net//api/notification/GetNotificationType", parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        //                        if "\(JSON.valueForKey("isError")!)" == "0" {
                        
                        let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                        
                        let data = JSON as! NSArray
                        
                        let database = databaseFile()
                        database.saveNotificationType(data)
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                        //                        }else{
                        //                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                        //                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        //                        }
                        //                        
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
        }

    }

    func registerUserDevice(UserID:String,DeviceUId:String,DeviceOS:String) {
        let notificationKey = "com.time-em.registerUserDevice"
        
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/User/RegisterUserDevice", parameters: ["UserID":UserID,"DeviceUId":DeviceUId,"DeviceOS":DeviceOS])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        //                        if "\(JSON.valueForKey("isError")!)" == "0" {
                        
                        let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                        
                        
                        
                        
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                }
        }
    }
    
    func getActiveUserList(userid:String,timeStamp:String) {
        let notificationKey = "com.time-em.NotificationTypeloginResponse"
        
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/user/GetActiveUserList", parameters:  ["UserId":userid,"timeStamp":timeStamp])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("IsError")!)" == "false" {
                        
                        let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                        
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record found!") != nil{
                                NSUserDefaults.standardUserDefaults().setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "activeUserListTimeStamp")
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                return
                            }
                            
                        NSUserDefaults.standardUserDefaults().setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "activeUserListTimeStamp")
                        let data = JSON.valueForKey("activeuserlist") as! NSArray
                        let database = databaseFile()
                            
                            for i in data {
                                 database.saveNotificationActiveUserList("\(i.valueForKey("FullName")!)", userid: "\(i.valueForKey("userid")!)")
                            }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                            }else{
                                let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                                }
                        //
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
        }
        
    }
    //http://timeemapi.azurewebsites.net/api/User/GetUsersListByLoginCode?Logincode=9105
    func getuserListByLoginCode(Logincode:String) {
        let notificationKey = "com.time-em.getuserListByLoginCode"
        
        Alamofire.request(.GET, "http://timeemapi.azurewebsites.net/api/User/GetUsersListByLoginCode", parameters:  ["Logincode":Logincode])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        print(JSON.valueForKey("isError"))
                        print(JSON.valueForKey("Message"))
                        
                        let userInfo = ["response" : "success"]
                        
                        let data = JSON.valueForKey("AppUserViewModel")! as! NSArray
                        print(data.count)
                        
                        let userDict = NSKeyedArchiver.archivedDataWithRootObject(data)
                       
                        NSUserDefaults.standardUserDefaults().setObject(userDict, forKey: "getuserListByLoginCode")
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                       
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
        }
        
    }
    func sendSyncDataToServer(dataArr:NSMutableArray) {
        let notificationKey = "com.time-em.sendSyncDataToServer"
        
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/UserActivity/Sync", parameters:  ["userTaskActivities":dataArr])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        print(JSON.valueForKey("isError"))
                        print(JSON.valueForKey("Message"))
                        
                        let userInfo = ["response" : "success"]
                        
                        
                        
                        
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                }
        }
    }
    
    
    
    func addUpdateTaskSynk(dataArr:NSMutableArray,type:String,uniqueno:String,data:NSData,view:UIView) {
        let notificationKey = "com.time-em.addUpdateTaskSynk"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        //--
      let  param = ["userTaskActivities":dataArr]
        print(param)
        let url = NSURL(string: "http://timeemapi.azurewebsites.net/api/UserActivity/Sync")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        for (key, value) in param {
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(value)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        var image = UIImage()
        var count:Int = 0
        if type == "image"{
         image = UIImage(data: data)!
             count = data.length / sizeof(UInt8)
            
        }

        if(count > 0)
        {
            let fname = "\(uniqueno).png"
            let mimetype = "image/png"
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(data)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        if type == "video" {
            let fname = "\(uniqueno).mp4"
            let mimetype = "video/.mp4"
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(data)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                let userInfo = ["response" : "failure"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                delay(0.001){
                    MBProgressHUD.hideHUDForView(view, animated: true)
                }
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print(dataString)
            
           
            
            delay(0.001){
                MBProgressHUD.hideHUDForView(view, animated: true)
                if "\(dataString!.lowercaseString)".rangeOfString("activity id does not exist") != nil{
                    let userInfo = ["response" : "please signin before adding task"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    return
                }
                let userInfo = ["response" : "SUCCESS"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            }
        }
        
        task.resume()
    }
    
    
//http://timeemapi.azurewebsites.net/api/notification/NotificationByUserId
    func getNotifications(UserId:String,timeStamp:String) {
        let notificationKey = "com.time-em.getNotificationListByLoginCode"
        
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/notification/NotificationByUserId", parameters:  ["UserId":UserId,"timeStamp":timeStamp])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        print(JSON.valueForKey("isError"))
                        print(JSON.valueForKey("Message"))
                        
                        if "\(JSON.valueForKey("IsError")!)" == "0" {
                             let userInfo = ["response" : "success"]
                            NSUserDefaults.standardUserDefaults().setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "notificationsTimeStamp")
                            
                           
                            if JSON.valueForKey("notificationslist") is NSNull
                            {
                                return
                            }
                            let dataArr = JSON.valueForKey("notificationslist") as? NSArray
                            if ( dataArr != nil)
                            {
                                let database = databaseFile()
                                
                                for i in dataArr! {
                                    
                                    let  AttachmentFullPath:String
                                    if let field = i.valueForKey("AttachmentFullPath") as? String {
                                        AttachmentFullPath = field
                                    }else{
                                        AttachmentFullPath = ""
                                    }
                                    
                                    let  Message:String
                                    if let field = i.valueForKey("Message") as? String {
                                        Message = field
                                    }else{
                                        Message = ""
                                    }
                                    let  NotificationId: Int!
                                    if let field = i.valueForKey("NotificationId")  {
                                        NotificationId = field as! Int
                                    }else{
                                        NotificationId = 0
                                    }
                                    let  NotificationTypeName:String
                                    if let field = i.valueForKey("NotificationTypeName") as? String {
                                        NotificationTypeName = field
                                    }else{
                                        NotificationTypeName = ""
                                    }
                                    let  SenderFullName:String
                                    if let field = i.valueForKey("SenderFullName") as? String {
                                        SenderFullName = field
                                    }else{
                                        SenderFullName = ""
                                    }
                                    let  Senderid: Int!
                                    if let field = i.valueForKey("Senderid")  {
                                        Senderid = field as! Int
                                    }else{
                                        Senderid = 0
                                    }
                                    let  Subject:String
                                    if let field = i.valueForKey("Subject") as? String {
                                        Subject = field
                                    }else{
                                        Subject = ""
                                    }
                                    let  createdDate:String
                                    if let field = i.valueForKey("createdDate") as? String {
                                        createdDate = field
                                    }else{
                                        createdDate = ""
                                    }
                                    
                                    database.saveNotifications(AttachmentFullPath, Message: Message, NotificationId: "\(NotificationId!)", NotificationTypeName: NotificationTypeName, SenderFullName: SenderFullName, Senderid: "\(Senderid!)", Subject: Subject, createdDate: createdDate)
                                }
                            }
                            
                            
                             NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }else{
                             let userInfo = ["response" : "failure"]
                             NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        }
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
        }
        
    }
    
    
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}








