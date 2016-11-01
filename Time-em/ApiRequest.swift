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

public class ApiRequest:UIViewController {
    
 //   let apiUrl:String = "http://timeemapi.azurewebsites.net/api"  // live
    let apiUrl:String = "http://timeem-staging.azurewebsites.net/api"
//    let apiUrl: String = "http://112.196.24.202:8080/api" // for location testing
//    let apiUrl: String = "http://112.196.24.205:804/api"
    var taskORsync:String = ""
    
    func loginApi(loginId:String,password:String,view:UIView) {
        let notificationKey = "com.time-em.loginResponse"
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
           return
        }
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        Alamofire.request(.GET, "\(apiUrl)/User/GetValidateUser", parameters: ["loginId":loginId,"password":password])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
        if "\(response.result)" == "SUCCESS"{
            let userInfo = ["response" : "SUCCESS"]
           
            if JSON.valueForKey("ReturnMessage") != nil {
                if "\(JSON.valueForKey("ReturnMessage")!)".lowercaseString == "login id or password not correct. please try again." {
                    let userInfo = ["response" : "\(JSON.valueForKey("ReturnMessage")!)"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                
                    MBProgressHUD.hideHUDForView(view, animated: true)
                    return
                }
                if "\(JSON.valueForKey("ReturnMessage")!)".lowercaseString == "login id doesn't exist!" {
                    let userInfo = ["response" : "\(JSON.valueForKey("ReturnMessage")!)"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                    MBProgressHUD.hideHUDForView(view, animated: true)
                    return
                }
            }
            if let field = JSON.valueForKey("Message")   as? String{
                
                
                
                if "\(JSON.valueForKey("Message")!)".lowercaseString == "an error has occurred." {
                    let userInfo = ["response" : "failure"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                    MBProgressHUD.hideHUDForView(view, animated: true)
                    return
                }
            }
            
            
            
            let currentUsers =  User(dict: JSON as! NSDictionary)
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Id)", forKey: "currentUser_id")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.IsSignIn)", forKey: "currentUser_IsSignIn")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.ActivityId)", forKey: "currentUser_ActivityId")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.LoginId)", forKey: "currentUser_LoginId")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.FullName)", forKey: "currentUser_FullName")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.UserTypeId)", forKey: "UserTypeId")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Email)", forKey: "currentUser_Email")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.PhoneNumber)", forKey: "currentUser_PhoneNumber")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.LoginCode)", forKey: "currentUser_LoginCode")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Pin)", forKey: "currentUser_Pin")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.UserType)", forKey: "currentUser_UserType")
            NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Company)", forKey: "currentUser_company")
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "forGraph")

            var dictionary:NSMutableDictionary = [:]
            dictionary = currentUsers.returnDict()
            
            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(dictionary)

            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")

            let database = FMDatabase(path: fileURL!.path)
            
            if !database.open() {
                print("Unable to open database")
                return
            }
            
            do {
                try database.executeUpdate("create table tasksData(ActivityId text, AttachmentImageFile text, AttachmentVideoFile text ,Comments text, CreatedDate text, EndTime text,Id text, SelectedDate text, SignedInHours text,StartTime text, TaskId text, TaskName text,TimeSpent text, Token text, UserId text, AttachmentImageData text,isVideoRecorded text, isoffline text, uniqueno text, CompanyId text)", values: nil)
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
                try database.executeUpdate("create table geofensingGraph(CreatedDate text, workSiteList text, userId text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table notificationtype(data text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table notificationActiveUserList(userid text,FullName text,companyid text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table notificationsTable(AttachmentFullPath text,Message text,NotificationId text,NotificationTypeName text,SenderFullName text,Senderid text,Subject text,createdDate text,companyid text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table sync(type text, data text ,id integer primary key autoincrement)", values: nil)
            } catch let error as NSError {
                print("sync failed: \(error.localizedDescription)")
            }
            do {
                try database.executeUpdate("create table assignedTaskList(TaskId text, TaskName text, companyid text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            
            do {
                try database.executeUpdate("create table TasksList(timespent text, date text,companyId text)", values: nil)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            
            do {
                try database.executeUpdate("create table UserSignedList(signedout text, signedin text, date text, companyId text)", values: nil)
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
        Alamofire.request(.POST, "\(apiUrl)/UserTask/DeleteTask", parameters: ["Id":Id])
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
                            
                            let databse = databaseFile()
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
        Alamofire.request(.GET, "\(apiUrl)/User/GetValidateUserByPin", parameters: ["loginId":loginId,"SecurityPin":SecurityPin])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        let userInfo = ["response" : "SUCCESS"]
                         if JSON.valueForKey("isError") == nil {
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            
                            return
                        }
                        
                        if "\(JSON.valueForKey("isError")!)" != "0" {
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            
                            return
                        }
                        
                        let currentUsers =  User(dict: JSON as! NSDictionary)
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Id)", forKey: "currentUser_id")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.IsSignIn)", forKey: "currentUser_IsSignIn")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.ActivityId)", forKey: "currentUser_ActivityId")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.LoginId)", forKey: "currentUser_LoginId")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.FullName)", forKey: "currentUser_FullName")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.UserTypeId)", forKey: "UserTypeId")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Email)", forKey: "currentUser_Email")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.PhoneNumber)", forKey: "currentUser_PhoneNumber")
                        NSUserDefaults.standardUserDefaults().setObject("no", forKey: "forGraph")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.UserType)", forKey: "currentUser_UserType")
                        NSUserDefaults.standardUserDefaults().setObject("\(currentUsers.Company)", forKey: "currentUser_company")
                        
                        var dictionary:NSMutableDictionary = [:]
                        dictionary = currentUsers.returnDict()
                        
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
                        
                        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                        
                        let database = FMDatabase(path: fileURL!.path)
                        
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
        
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        Alamofire.request(.POST, "\(apiUrl)/UserTask/GetUserActivityTask", parameters: ["userId":userId,"createdDate":createdDate, "TimeStamp":"", "CompanyId" : str])
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
                                if (saveDateDict.valueForKey(createdDate) != nil) {
                                    
                                    saveDateDict.removeObjectForKey(createdDate)
                                    
                                    saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: createdDate)
                                }
                                else {
                                    
                                    saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: createdDate)
                                }
                            }
                            else {
                                saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: createdDate)
                            }
                            let data1: NSData = NSKeyedArchiver.archivedDataWithRootObject(saveDateDict)
                            user.setObject(data1,forKey:"taskTimeStamp")
                            //-------------
                        }
                        
                        
                        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                        
                        let database = FMDatabase(path: fileURL!.path)
                        
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
                        
                        
                        
                        
                        for i in (0 ..< dict.count){
                            
                            let  ActivityId:Int!
                            if let field = dict[i].valueForKey("ActivityId")   {
                                ActivityId = field as! Int
                            }else{
                                ActivityId = 0
                            }
                            
                            var CompanyId:Int!
                            if let field = dict[i].valueForKey("CompanyId")   {
                                CompanyId = field as! Int
                            }else{
                                CompanyId = 0
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
                                    try database.executeUpdate("UPDATE tasksData SET ActivityId = ? , AttachmentImageFile = ? , AttachmentVideoFile = ?  ,Comments = ? , CreatedDate = ? , EndTime  = ?, SelectedDate  = ?, SignedInHours = ?,StartTime = ? , TaskId = ? , TaskName = ? ,TimeSpent = ? , Token = ? , UserId = ? ,CompanyId = ? WHERE Id=?", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId ,CompanyId , Id])
                                } catch let error as NSError {
                                    print("failed: \(error.localizedDescription)")
                                }
                                
                            }else{
                                if isActive == 0 {
                                    continue
                                }
                                
                                do {
                                    //                    try database.executeUpdate("delete * from  tasksData", values: nil)
                                    try database.executeUpdate("insert into tasksData (ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId, AttachmentImageData,uniqueno ,CompanyId) values (?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?, ?,?,?)", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId ,"", "" ,CompanyId])
                                    
                                } catch let error as NSError {
                                    print("failed: \(error.localizedDescription)")
                                }
                            }
                            
                        }
                        database.close()
                        MBProgressHUD.hideHUDForView(view, animated: true)

                        let userInfo = ["response" : "SUCCESS"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
                        
                        
                        
                        
                        MBProgressHUD.hideHUDForView(view, animated: true)

                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    MBProgressHUD.hideHUDForView(view, animated: true)

                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
                MBProgressHUD.hideHUDForView(view, animated: true)
        }
        
    }
    
    func fetchAllTaskAtOnce(userId:String,createdDate:String){
        
        let notificationKey = "com.time-em.usertaskResponse"
        
        let status:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("isEditingOrAdding")!)"
        if status.lowercaseString == "true" {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey:"isEditingOrAdding")
            MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
        
        Alamofire.request(.POST, "\(apiUrl)/UserTask/GetAllTaskList", parameters: ["userId":userId,"createdDate":"", "TimeStamp":"", "CompanyId" : "0"])
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
                                if (saveDateDict.valueForKey(createdDate) != nil) {
                                    
                                    saveDateDict.removeObjectForKey(createdDate)
                                    
                                    saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: createdDate)
                                }
                                else {
                                    
                                    saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: createdDate)
                                }
                            }
                            else {
                                saveDateDict.setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: createdDate)
                            }
                            let data1: NSData = NSKeyedArchiver.archivedDataWithRootObject(saveDateDict)
                            user.setObject(data1,forKey:"taskTimeStamp")
                            //-------------
                        }
                        
                        
                        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                        
                        let database = FMDatabase(path: fileURL!.path)
                        
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
                        
                        
                        
                        
                        for i in (0 ..< dict.count){
                            
                            let  ActivityId:Int!
                            if let field = dict[i].valueForKey("ActivityId")   {
                                ActivityId = field as! Int
                            }else{
                                ActivityId = 0
                            }
                            
                            var CompanyId:Int!
                            if let field = dict[i].valueForKey("CompanyId")   {
                                CompanyId = field as! Int
                            }else{
                                CompanyId = 0
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
                                    try database.executeUpdate("UPDATE tasksData SET ActivityId = ? , AttachmentImageFile = ? , AttachmentVideoFile = ?  ,Comments = ? , CreatedDate = ? , EndTime  = ?, SelectedDate  = ?, SignedInHours = ?,StartTime = ? , TaskId = ? , TaskName = ? ,TimeSpent = ? , Token = ? , UserId = ? ,CompanyId = ? WHERE Id=?", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId ,CompanyId , Id])
                                } catch let error as NSError {
                                    print("failed: \(error.localizedDescription)")
                                }
                                
                            }else{
                                if isActive == 0 {
                                    continue
                                }
                                
                                do {
                                    //                    try database.executeUpdate("delete * from  tasksData", values: nil)
                                    try database.executeUpdate("insert into tasksData (ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId, AttachmentImageData,uniqueno ,CompanyId) values (?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?, ?,?,?)", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId ,"", "" ,CompanyId])
                                    
                                } catch let error as NSError {
                                    print("failed: \(error.localizedDescription)")
                                }
                            }
                            
                        }
                        database.close()
//                        MBProgressHUD.hideHUDForView(view, animated: true)
                        
                        let userInfo = ["response" : "SUCCESS"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
                        
                        
                        
                        
//                        MBProgressHUD.hideHUDForView(view, animated: true)
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
//                    MBProgressHUD.hideHUDForView(view, animated: true)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    
                }
                
//                MBProgressHUD.hideHUDForView(view, animated: true)
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
        
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "\(apiUrl)/UserActivity/SignOutByUserId", parameters: ["Userids":userId,"CompanyId":str])
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
                                let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
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
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "\(apiUrl)/UserActivity/SignInByUserId", parameters: ["Userids":userId,"CompanyId":str])
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
                                NSUserDefaults.standardUserDefaults().setObject("\(1)", forKey: "currentUser_IsSignIn")
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                
                                let arr = JSON.valueForKey("SignedinUser") as? NSArray
                                
//                                let database1 = databaseFile()
//                                database1.currentUserSignIn(arr!)

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
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        Alamofire.request(.POST, "\(apiUrl)/User/GetAllUsersList", parameters: ["userId":userId,"TimeStamp":"","CompanyId":str])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
                            
                            // delete old data if new data doesnot exist
                            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                            
                            let database = FMDatabase(path: fileURL!.path)
                            
                            if !database.open() {
                                print("Unable to open database")
                            }
                            let compId =  "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)"
                            
                            do {
                                try database.executeUpdate("delete  from  teamData WHERE companyId=?", values: [compId])
                            }catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            database.close()
                            //---
                            
                            
                            
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)

                            return
                        }
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSUserDefaults.standardUserDefaults().setObject(JSON.valueForKey("TimeStamp"), forKey: "teamTimeStamp")
                            let dict = JSON.valueForKey("AppUserViewModel") as! NSArray
                            var idStr:String = ""
                            for c in (0 ..< dict.count){
                                if c == 0 {
                                   idStr = "\(dict[0].valueForKey("Id")!)"
                                }else{
                                   idStr = "\(idStr),\(dict[c].valueForKey("Id")!)"
                                }
                                
                            }
                            
                    if NSUserDefaults.standardUserDefaults().valueForKey("exicuteOnlyOnce") != nil {
            print(NSUserDefaults.standardUserDefaults().valueForKey("exicuteOnlyOnce"))
                             if "\(NSUserDefaults.standardUserDefaults().valueForKey("exicuteOnlyOnce")!)" == "true"{
                        NSUserDefaults.standardUserDefaults().setObject("false", forKey:"exicuteOnlyOnce")
                                let assignedTasks = ApiRequest()
                                assignedTasks.GetUserWorksiteListActivity(idStr, view: self.view)
                        }
                }

                            print(idStr)
                            
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
    
    func getTeamOfflineAtStart(userId:String){
        let notificationKey = "com.time-em.getTeamResponse"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
//        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        
        Alamofire.request(.POST, "\(apiUrl)/user/GetAllUsersListOffline", parameters: ["userId":userId,"TimeStamp":"","CompanyId":"0"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
                            
                            // delete old data if new data doesnot exist
                            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                            
                            let database = FMDatabase(path: fileURL!.path)
                            
                            if !database.open() {
                                print("Unable to open database")
                            }
                            let compId =  "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)"
                            
                            do {
                                try database.executeUpdate("delete  from  teamData WHERE companyId=?", values: [compId])
                            }catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            database.close()
                            //---
                            
                            
                            
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                            MBProgressHUD.hideHUDForView(view, animated: true)
                            
                            return
                        }
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                           
                            let dict = JSON.valueForKey("AppUserViewModel") as! NSArray
                            var idStr:String = ""
                            for c in (0 ..< dict.count){
                                if c == 0 {
                                    idStr = "\(dict[0].valueForKey("Id")!)"
                                }else{
                                    idStr = "\(idStr),\(dict[c].valueForKey("Id")!)"
                                }
                                
                            }
                            
                            if NSUserDefaults.standardUserDefaults().valueForKey("exicuteOnlyOnce") != nil {
                                print(NSUserDefaults.standardUserDefaults().valueForKey("exicuteOnlyOnce"))
                                if "\(NSUserDefaults.standardUserDefaults().valueForKey("exicuteOnlyOnce")!)" == "true"{
                                    NSUserDefaults.standardUserDefaults().setObject("false", forKey:"exicuteOnlyOnce")
                                    let assignedTasks = ApiRequest()
                                    assignedTasks.GetUserWorksiteListActivity(idStr, view: self.view)
                                }
                            }
                            
                            print(idStr)
                            
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
//                MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    
    func fetchUserTaskGraphDataFromAPI(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.getUserTaskGraphData"
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        Alamofire.request(.GET, "\(apiUrl)/usertask/UserTaskGraph", parameters: ["userId":userId,"CompanyId":str])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
                            
                            
                            // delete old data if new data doesnot exist
                            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                            
                            let database = FMDatabase(path: fileURL!.path)
                            
                            if !database.open() {
                                print("Unable to open database")
                            }
                            let compId =  "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)"
                            
                            do {
                                try database.executeUpdate("delete  from  TasksList WHERE companyId=?", values: [compId])
                            }catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            database.close()
                            //---
                            
                            
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
    //--
    func sendUsersTimeIn(userId:String,points:String)  {
        let notificationKey = "com.time-em.sendUsersTimeIn"
        //UserId,points(latitude,longitude)
        Alamofire.request(.POST, "\(apiUrl)/Worksite/AddUsersTimeIn", parameters: ["UserId":userId,"points":points])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            
                            
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
                
//                MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
    func fetchUserSignedGraphDataFromAPI(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.getUserSignedGraphData"
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        Alamofire.request(.GET, "\(apiUrl)/usertask/UsersGraph", parameters: ["userId":userId,"CompanyId":str])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
                            
                            
                            // delete old data if new data doesnot exist
                            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                            
                            let database = FMDatabase(path: fileURL!.path)
                            
                            if !database.open() {
                                print("Unable to open database")
                            }
                            let compId =  "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)"
                            
                            do {
                                try database.executeUpdate("delete  from  UserSignedList WHERE companyId=?", values: [compId])
                            }catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            database.close()
                            //---

                            
                            
                            
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
    
    //--
    func GetUserWorksiteActivityGraph(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.getUserSignedGraphData"
        
        Alamofire.request(.GET, "\(apiUrl)/Worksite/GetUserWorksiteActivity", parameters: ["userid":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
//                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record") != nil{
//                            let userInfo = ["response" : "FAILURE"]
//                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                            return
//                        }
                        print(JSON.count)
                        
                        let dataArr:NSArray = JSON as! NSArray
                        
                        let database = databaseFile()
                        database.saveUserWorksiteActivityGraph(dataArr,userId:userId)
                        
                        
                       
                        
                        
                        
                        
                        
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            
                            
                            
                            
                        
                            
                            
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
    func GetUserWorksiteListActivity(userId:String,view:UIView)  {
//        let notificationKey = "com.time-em.getUserSignedGraphData"
        let notificationKey = ""
        Alamofire.request(.GET, "\(apiUrl)/Worksite/GetUserlistWorksiteActivity", parameters: ["userid":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                                                if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("error has occurred") != nil{
                                                    let userInfo = ["response" : "FAILURE"]
                                                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                                    return
                                                }
                        print(JSON.count)
                        
                        let dataArr:NSArray = JSON as! NSArray
                        
                        let database = databaseFile()
                        database.saveUserWorksiteActivityGraphAllUsers(dataArr,userId:userId)
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            
                            
                            
                            
                            
                            
                            
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
        delay(0.001){
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
        
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        
        Alamofire.request(.GET, "\(apiUrl)/Task/GetAssignedTaskIList", parameters: ["userId":userId,"CompanyId":str])
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
    
    func getAssignedTaskListOfflineATStart (userId:String){
        
        Alamofire.request(.GET, "\(apiUrl)/Task/GetAllAssignedTaskIList", parameters: ["userId":userId,"CompanyId":"0"])
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
                
//                MBProgressHUD.hideHUDForView(view, animated: true)
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
            

            
            let arr:NSMutableArray = database.getDataFromSync()
            if arr.count != 0{
                for i in (0 ..< arr.count){
//                for dictDATA in arr {
                    let dictDATA:NSMutableDictionary = arr[i] as! NSMutableDictionary;
                    if dictDATA.valueForKey("AddUpdateNewTask") != nil {
                        
                        
                        
                        let userArr:NSArray = (dictDATA.valueForKey("AddUpdateNewTask") as? NSArray)!
                        
                        let uniqueNo = "\(userArr[11])"
                        if (uniqueNo == uniqueno){
                          let countNo = "\(userArr[13])"
                            database.deleteSYNCDataForID(countNo)
                            
                            
                            /////------
                            
                            let issignedin:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)"
                            if issignedin == "0" {
                                
                                let userInfo = ["response" : "Signin before adding task."]
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                return
                            }
                            print("Internet connection FAILED")
                            view.makeToast("Internet connection FAILED. Request saved in sync")
                            let uniqueno:String = "\(UserId)\(currentTimeMillis())"
                            
                            let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
                            
                            
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
                            array.addObject(str)
                            let database = databaseFile()
                            database.addDataToSync("AddUpdateNewTask", data: array)
                            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
                            /////-------
                        }
                        
                       
                    }
                }
                
                database.addTaskSync(imageData, videoData: videoData, ActivityId: ActivityId, TaskId: TaskId, UserId: UserId, TaskName: TaskName, TimeSpent: TimeSpent, Comments: Comments, CreatedDate: CreatedDate, ID: ID, isVideoRecorded: "\(isVideoRecorded)",uniqueno:uniqueno)
                let userInfo = ["response" : "success"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            }
            
            
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
            
            let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

            
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
            array.addObject(str)
            let database = databaseFile()
            database.addDataToSync("AddUpdateNewTask", data: array)
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
            //
            
            database.addTaskSync(imageData, videoData: videoData, ActivityId: ActivityId, TaskId: TaskId, UserId: UserId, TaskName: TaskName, TimeSpent: TimeSpent, Comments: Comments, CreatedDate: CreatedDate, ID: ID, isVideoRecorded: "\(isVideoRecorded)",uniqueno:uniqueno)
            let userInfo = ["response" : "success sync"]
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            
            return
        }

        //--
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        let companyKey:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        let param = [
            "ActivityId"    :ActivityId,
            "TaskId"        :TaskId,
            "UserId"        :UserId,
            "TaskName"      :TaskName,
            "TimeSpent"     :TimeSpent,
            "Comments"      :Comments,
            "CreatedDate"   :CreatedDate,
            "ID"            :ID,
            "CompanyId"     :companyKey
        ]
                print(param)
        let url = NSURL(string: "\(apiUrl)/usertask/AddUpdateUserTaskActivityNew")
        
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
//        if(image != nil)
//        {
//            let fname = "test.png"
//            let mimetype = "image/png"
//            
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData(imageData)
//            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        }
        
//        if isVideoRecorded {
//            let fname = "testVideo.mp4"
//            let mimetype = "video/.mp4"
//            
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData(videoData)
//            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        }
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            (
             data,  response, error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response   else {
                print("error")
                let userInfo = ["response" : "Failed to add task. Kindly try again."]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                delay(0.001){
                    MBProgressHUD.hideHUDForView(view, animated: true)
                }
                return
            }
            
            let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            
            let str = dataString?.componentsSeparatedByString("\"Id\":")[1]
          let str1 =  str!.componentsSeparatedByString(",")[0]
            
            
//            let stringArray = dataString!.componentsSeparatedByCharactersInSet(
//                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
//            let newString = stringArray.joinWithSeparator("")
            let newString = str1
             print(newString)
            
            let count1 = imageData.length / sizeof(UInt8)
            let count2 = videoData.length / sizeof(UInt8)

            
            if count1 > 0 || count2 > 0 {
            var type:String = ""
            var dataobject:NSData!
            if isVideoRecorded{
                type = "video"
                dataobject = videoData
            }else{
                type = "image"
                dataobject = imageData
            }
            
            self.taskORsync = "task"
                NSUserDefaults.standardUserDefaults().setObject("no", forKey: "forSync")
            self.sendImageVideoSync(newString, FileUploadFor: "usertaskactivity", data: dataobject, type: type, uniqueno: newString, view: view)
            }
            
            
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
                if "\(dataString!.lowercaseString)".rangeOfString("Failure in adding task") != nil{
                    let userInfo = ["response" : "Failure in adding task."]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    return
                }
                let userInfo = ["response" : "SUCCESS"]
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            }
        }
        
        task.resume()
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
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

            
            let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

            
            let array:NSMutableArray = []
            array.addObject(imageData)
            array.addObject(UserId)
            array.addObject(Subject)
            array.addObject(Message)
            array.addObject(NotificationTypeId)
            array.addObject(notifyto)
            array.addObject(str)
//            array.addObject(view)
            
            let database = databaseFile()
            database.addDataToSync("sendNotification", data: array)
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey:"sync")
            
            let userInfo = ["response" : "successfully"]
            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        let param = [
            "UserId"                   :UserId,
            "Subject"                   :Subject,
            "Message"                   :Message,
            "NotificationTypeId"       :NotificationTypeId,
            "notifyto"                  :notifyto,
            "CompanyId"                 :str
        ]
        //        print(param)
        let url = NSURL(string: "\(apiUrl)/notification/AddNotificationNew")
        
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
//        if(image != nil)
//        {
//            let fname = "test.png"
//            let mimetype = "image/png"
//            
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData(imageData)
//            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        }
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            (
             data,  response,  error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response   else {
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
            //--
            
            
                if "\(dataString!.lowercaseString)".rangeOfString("an error occured") != nil{
                    let userInfo = ["response" : "Faild to send notification. Kindly try again."]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    delay(0.001){
                        MBProgressHUD.hideHUDForView(view, animated: true)
                        }
                    return
                }
            
            
            
            //--
            let arr = dataString?.componentsSeparatedByString(",\"Id\":")[1]
            
            let sttt = arr?.componentsSeparatedByString(",")[0]
            
            let stringArray = dataString!.componentsSeparatedByCharactersInSet(
                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
//            let newString = stringArray.joinWithSeparator("")
              let newString = sttt
            print(newString)
            
            let count1 = imageData.length / sizeof(UInt8)
            
            
            if count1 > 0 {
                var type:String = ""
                var dataobject:NSData!
                
                    type = "image"
                    dataobject = imageData
                
                
                self.taskORsync = "noti"
                NSUserDefaults.standardUserDefaults().setObject("no", forKey: "forSync")

                self.sendImageVideoSync(newString!, FileUploadFor: "notification", data: dataobject, type: type, uniqueno: newString!, view: view)
            }
            
            
            
            
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
        Alamofire.request(.POST, "\(apiUrl)/USER/ForgetPassword", parameters: ["email":emailId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON)".lowercaseString == "your request is not completed" {
                            let userInfo = ["response" : "your request is not completed"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                        return
                        }
                        if "\(JSON)".lowercaseString == "no user exists with this email" {
                            let userInfo = ["response" : "no user exists with this email"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            return
                        }
                        
                        
                        let userInfo = ["response" : "SUCCESS"]
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        
                    }else{
                        let userInfo = ["response" : "\(JSON)"]
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
        Alamofire.request(.POST, "\(apiUrl)/USER/ForgetPin", parameters: ["email":emailId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON)".lowercaseString == "your request is not completed" {
                            let userInfo = ["response" : "your request is not completed"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            return
                        }
                        if "\(JSON)".lowercaseString == "no user exists with this email" {
                            let userInfo = ["response" : "no user exists with this email"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            return
                        }
                        
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
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "\(apiUrl)/UserActivity/SignInByUserId", parameters: ["Userids":userId,"CompanyId":str])
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
        
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "\(apiUrl)/UserActivity/SignOutByUserId", parameters: ["Userids":userId,"CompanyId":str])
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
                            
                            if "\(JSON.valueForKey("Message")!)".lowercaseString ==  "user already signed out." {
                                
                                 let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                                let databse = databaseFile()
                                databse.teamSignOutbyId(userId)
                              NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                MBProgressHUD.hideHUDForView(view, animated: true)

                                return
                            }
                            
                            
                            
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
        
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "\(apiUrl)/UserActivity/SignInByUserId", parameters: ["Userids":userId,"CompanyId":str])
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
                                
                                print("aa")
                                let idArray = userId.componentsSeparatedByString(",")
                                let database = databaseFile()
                                for k in idArray {
                                    database.teamSignInUpdate(k)
                                }
                                MBProgressHUD.hideHUDForView(view, animated: true)

                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
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
        
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, "\(apiUrl)/UserActivity/SignOutByUserId", parameters: ["Userids":userId,"CompanyId":str])
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
                                MBProgressHUD.hideHUDForView(view, animated: true)
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
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
        
        let database = FMDatabase(path: fileURL!.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
    }
    
    func GetNotificationType() {
        let notificationKey = "com.time-em.NotificationTypeloginResponse"
        
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        Alamofire.request(.GET, "\(apiUrl)/notification/GetNotificationType", parameters: ["CompanyId":str])
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
        
        Alamofire.request(.POST, "\(apiUrl)/User/RegisterUserDevice", parameters: ["UserID":UserID,"DeviceUId":DeviceUId,"DeviceOS":DeviceOS])
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
    
    func getActiveUserList(userid:String,timeStamp:String,view:UIView) {
        let notificationKey = "com.time-em.NotificationTypeloginResponse"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        Alamofire.request(.POST, "\(apiUrl)/user/GetActiveUserList", parameters:  ["UserId":userid,"timeStamp":"","CompanyId":str])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                //sadasdsadasdasd
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("IsError")!)" == "false" {
                        
                        let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                        
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record found!") != nil{
                                NSUserDefaults.standardUserDefaults().setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "activeUserListTimeStamp")
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                                MBProgressHUD.hideHUDForView(view, animated: true)
                                return
                            }
                            
                        NSUserDefaults.standardUserDefaults().setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "activeUserListTimeStamp")
                        let data = JSON.valueForKey("activeuserlist") as! NSArray
                        let database = databaseFile()
                            
                            for i in data {
                                 database.saveNotificationActiveUserList("\(i.valueForKey("FullName")!)", userid: "\(i.valueForKey("userid")!)",CompanyId: "\(i.valueForKey("CompanyId")!)")
                              
                            }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        MBProgressHUD.hideHUDForView(view, animated: true)
                            }else{
                                let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                                                }
                        //
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                        MBProgressHUD.hideHUDForView(view, animated: true)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    MBProgressHUD.hideHUDForView(view, animated: true)
                    
                }
                
        }
        
    }
    
    func getUserlistingforSendingNotiOffline(userid:String){
        let notificationKey = "com.time-em.NotificationTypeloginResponse"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        Alamofire.request(.POST, "\(apiUrl)/user/GetActiveUserListoffline", parameters:  ["UserId":userid,"timeStamp":"","CompanyId":"0"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                //sadasdsadasdasd
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("IsError")!)" == "false" {
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            
                            if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("no record found!") != nil{
                                NSUserDefaults.standardUserDefaults().setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "activeUserListTimeStamp")
                                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                                MBProgressHUD.hideHUDForView(view, animated: true)
                                return
                            }
                            
//                            NSUserDefaults.standardUserDefaults().setObject("\(JSON.valueForKey("TimeStamp")!)", forKey: "activeUserListTimeStamp")
                            let data = JSON.valueForKey("activeuserlist") as! NSArray
                            let database = databaseFile()
                            
                            for i in data {
                                database.saveNotificationActiveUserList("\(i.valueForKey("FullName")!)", userid: "\(i.valueForKey("userid")!)",CompanyId: "\(i.valueForKey("CompanyId")!)")
                                
                            }
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                            MBProgressHUD.hideHUDForView(view, animated: true)
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                            MBProgressHUD.hideHUDForView(view, animated: true)
                        }
                        //
                        
                    }else{
                        let userInfo = ["response" : "FAILURE"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                        MBProgressHUD.hideHUDForView(view, animated: true)
                    }
                }else if "\(response.result)" == "FAILURE"{
                    let userInfo = ["response" : "FAILURE"]
                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                    MBProgressHUD.hideHUDForView(view, animated: true)
                    
                }
                
        }
        
    }
    
    
    
    //http://timeemapi.azurewebsites.net/api/User/GetUsersListByLoginCode?Logincode=9105
    func getuserListByLoginCode(Logincode:String,view:UIView) {
        let notificationKey = "com.time-em.getuserListByLoginCode"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        Alamofire.request(.GET, "\(apiUrl)/User/GetUsersListByLoginCode", parameters:  ["Logincode":Logincode,"CompanyId":str])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        print(JSON.valueForKey("IsError"))
                        print(JSON.valueForKey("Message"))
                        print("http:hello//")

                        if "\(JSON.valueForKey("Message")!)".rangeOfString("No Record Found !") != nil{
                          let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            return
                        }
                        
                        
                        
                        let userInfo = ["response" : "success"]
                        
                        let data = JSON.valueForKey("AppUserViewModel")! as! NSArray
                        print(data.count)
                        if data.count != 0{
                        let userDict = NSKeyedArchiver.archivedDataWithRootObject(data)
                       
                        NSUserDefaults.standardUserDefaults().setObject(userDict, forKey: "getuserListByLoginCode")
                        
                        
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
    
    func sendSyncDataToServer(dataArr:NSMutableArray,NotificationData:NSMutableArray,imagesDataDict:NSMutableDictionary,view:UIView) {
        let notificationKey = "com.time-em.sendSyncDataToServer"
        MBProgressHUD.showHUDAddedTo(view, animated: true)

        print(dataArr)
        var tempJson : NSString = ""
        var parameter:[String:AnyObject] = [:]
        let dict:NSMutableDictionary = [:]
        dict.setObject(dataArr, forKey: "userTaskActivities")
        dict.setObject(NotificationData, forKey: "notifications")
        do {
            let arrJson = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
            let string = NSString(data: arrJson, encoding: NSUTF8StringEncoding)
            tempJson = string! as NSString
            print(tempJson)
            parameter = ["data":tempJson]
        }catch let error as NSError{
            print(error.description)
        }
//        let dict:NSMutableDictionary = dataArr[0] as! NSMutableDictionary
//        print("$$$$\(dict.valueForKey("CreatedDate")!)")
//        print("$$$$\(dict.valueForKey("Comments")!)")
//        print("$$$$\(dict.valueForKey("UniqueNumber")!)")
//        print("$$$$\(dict.valueForKey("ActivityId")!)")
//        print("$$$$\(dict.valueForKey("TaskId")!)")
        Alamofire.request(.POST, "\(apiUrl)/UserActivity/Sync", parameters:parameter)
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
                        
                        
                        if "\(JSON.valueForKey("Message")!)" !=  "Sync Complete" || "\(JSON.valueForKey("isError")!)" !=  "0"{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)
                            return
                        }
                       NSUserDefaults.standardUserDefaults().setObject("\(imagesDataDict.count)", forKey: "noOfimages")
                        let notiArrayData:NSArray = (JSON.valueForKey("NotificationData") as? NSArray)!
                        if notiArrayData.count > 0 {
                            
                            for dictionary in notiArrayData {
                                
                                if dictionary.valueForKey("UniqueNumber") != nil {
                                    let idStr = "\(dictionary.valueForKey("Id")!)"
                                    let uniqueNoStr = "\(dictionary.valueForKey("UniqueNumber")!)"
                                    if imagesDataDict.valueForKey(uniqueNoStr) != nil{
                                        let array = (imagesDataDict.valueForKey(uniqueNoStr) as? NSArray)!
                                        let imageVideo = "\(array[0])"
                                        let data:NSData = (array[1] as? NSData)!
                                        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "forSync")
                                        self.taskORsync = ""
                                        self.sendImageVideoSync(idStr, FileUploadFor: "notification", data: data, type: imageVideo,uniqueno:uniqueNoStr,view: view)
                                    }
                                }
                                
                            }
                            // for loop end
                        }
                        
                        let UsersDataArray:NSArray = (JSON.valueForKey("UsersData") as? NSArray)!
                        if UsersDataArray.count > 0 {
                            
                            for dictionary in UsersDataArray {
                                
                                if dictionary.valueForKey("UniqueNumber") != nil {
                                    let idStr = "\(dictionary.valueForKey("Id")!)"
                                    let uniqueNoStr = "\(dictionary.valueForKey("UniqueNumber")!)"
                                    if imagesDataDict.valueForKey(uniqueNoStr) != nil{
                                        let array = (imagesDataDict.valueForKey(uniqueNoStr) as? NSArray)!
                                        let imageVideo = "\(array[0])"
                                        let data:NSData = (array[1] as? NSData)!
                                        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "forSync")
                                        self.taskORsync = ""
                                        self.sendImageVideoSync(idStr, FileUploadFor: "usertaskactivity", data: data, type: imageVideo,uniqueno:uniqueNoStr,view: view)
                                    }
                                }
                                
                            }
                            // for loop end
                        }
        
                        

                        if JSON.valueForKey("NotificationData")!.count
                        == 0 && JSON.valueForKey("UsersData")!.count
                            == 0 {
                            
                            let userInfo = ["response" : "FAILURE"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            MBProgressHUD.hideHUDForView(view, animated: true)

                            return
                            
                            
                        }else{
                        // delete sync data
                        let database:databaseFile = databaseFile()
                        database.deleteSYNCData()
                        database.deleteTasksSync()
                        }
                        
                        NSUserDefaults.standardUserDefaults().setObject("no", forKey:"sync")
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
    
    func sendImageVideoSync (Id:String,FileUploadFor:String,data:NSData,type:String,uniqueno:String,view:UIView) {
//        MBProgressHUD.showHUDAddedTo(view, animated: true)
        let notificationKey = "com.time-em.sendSyncDataToServer"
        var noOfImages:Int! = 1
        if NSUserDefaults.standardUserDefaults().valueForKey("noOfimages") != nil {
         noOfImages = Int("\(NSUserDefaults.standardUserDefaults().valueForKey("noOfimages")!)")!
        }
        var count:Int = 1
        NSUserDefaults.standardUserDefaults().setObject(count, forKey: "count")
        let loadingNotification:MBProgressHUD!
        if taskORsync == "task" ||  taskORsync == "noti" {
            
        }else{
         loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Uploading image...\(count)/\(noOfImages)"
            loadingNotification.progress = 0
            loadingNotification.show(true)
        }
        
        let interval:Int = 100/noOfImages
        
        let param = [
            "Id"    :Id,
            "FileUploadFor"        :FileUploadFor
                    ]
        print(param)
        let url = NSURL(string: "\(apiUrl)/UserActivity/SyncFileUpload")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var image = UIImage()
        if type == "image"{
         image = UIImage(data: data)!
        }
        
        let body = NSMutableData()
        
        for (key, value) in param {
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(value)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        if type == "image"
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
        
//        if isVideoRecorded {
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
             data,  response,  error) in
            delay(0.001){
            MBProgressHUD.hideAllHUDsForView(view, animated: true)
           var loadingNotification = MBProgressHUD()
             if self.taskORsync == "task" ||  self.taskORsync == "noti" {
             }else{
            loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.progress = 0
            loadingNotification.show(true)
            }
                
                let count1:Int = Int("\(NSUserDefaults.standardUserDefaults().valueForKey("count")!)")!
                count = count1 + 1
                NSUserDefaults.standardUserDefaults().setObject(count, forKey: "count")
            print(count)
                loadingNotification.labelText = "Uploading image...\(count)/\(noOfImages)"//

            if count > noOfImages {
                delay(0.001){
                    MBProgressHUD.hideHUDForView(view, animated: true)
                }
            }
            }
            guard let _:NSData = data, let _:NSURLResponse = response   else {
                print("\(error)")
                let userInfo = ["response" : "Failed to upload image. Kindly try again by edit the task."]
//                                
                NSNotificationCenter.defaultCenter().postNotificationName("com.time-em.usertasksResponsefromAddTask", object: nil, userInfo: userInfo)
                delay(0.001){
//                    MBProgressHUD.hideHUDForView(view, animated: true)
                }
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print(dataString)
            
            
            delay(0.001){
//                MBProgressHUD.hideHUDForView(view, animated: true)
                if "\(dataString!.lowercaseString)".rangeOfString("activity id does not exist") != nil{
                    let userInfo = ["response" : "Kindly sign in before adding task"]
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("com.time-em.usertasksResponsefromAddTask", object: nil, userInfo: userInfo)
//                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    return
                }else if "\(dataString!.lowercaseString)".rangeOfString("error occured") != nil{
                    let userInfo = ["response" : "Uploading failed. Kindly try again."]
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("com.time-em.usertasksResponsefromAddTask", object: nil, userInfo: userInfo)
                    //                    NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    return
                }
                
                
                
                let userInfo = ["response" : "image upload successfully"]
                NSNotificationCenter.defaultCenter().postNotificationName("com.time-em.usertasksResponsefromAddTask", object: nil, userInfo: userInfo)

//                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
            }
        }
        
        task.resume()
    }
    
    func addUpdateTaskSynk(dataArr:NSMutableArray,type:String,uniqueno:String,data:NSData,view:UIView) {
        let notificationKey = "com.time-em.addUpdateTaskSynk"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        //--
      let  param = ["userTaskActivities":dataArr]
        print(param)
        let url = NSURL(string: "\(apiUrl)/UserActivity/Sync")
        
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
             data,  response,  error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response   else {
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
        
         let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;
        

        Alamofire.request(.POST, "\(apiUrl)/notification/NotificationByUserId", parameters:  ["UserId":UserId,"timeStamp":timeStamp,"CompanyId":str])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        print(JSON.valueForKey("IsError"))
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
                                    let  CompanyId: Int!
                                    if let field = i.valueForKey("CompanyId")  {
                                        CompanyId = field as! Int
                                    }else{
                                        CompanyId = 0
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
                                    
                                    database.saveNotifications(AttachmentFullPath, Message: Message, NotificationId: "\(NotificationId!)", NotificationTypeName: NotificationTypeName, SenderFullName: SenderFullName, Senderid: "\(Senderid!)", Subject: Subject, createdDate: createdDate,CompanyId:"\( CompanyId)")
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
    
    func getAllNotificationsInStart(UserId:String){
        let notificationKey = "com.time-em.getNotificationListByLoginCode"
        
        

        Alamofire.request(.POST, "\(apiUrl)/notification/GetAllNotificationByUserId", parameters:  ["UserId":UserId,"timeStamp":"","CompanyId":"0"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        print(JSON.valueForKey("IsError"))
                        print(JSON.valueForKey("Message"))
                        if "\(JSON.valueForKey("Message")!)" == "No HTTP resource was found that matches the request URI 'http://timeem-staging.azurewebsites.net/api/notification/GetAllNotificationByUserId'." {
                            
                           return
                        }
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
                                    let  CompanyId: Int!
                                    if let field = i.valueForKey("CompanyId")  {
                                        CompanyId = field as! Int
                                    }else{
                                        CompanyId = 0
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
                                    
                                    database.saveNotifications(AttachmentFullPath, Message: Message, NotificationId: "\(NotificationId!)", NotificationTypeName: NotificationTypeName, SenderFullName: SenderFullName, Senderid: "\(Senderid!)", Subject: Subject, createdDate: createdDate,CompanyId: "\(CompanyId)")
                                    
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
    
    
    
    func newAddTaskwebservice(ActivityId:String,TaskId:String,UserId:String,TaskName:String,TimeSpent:String,Comments:String,CreatedDate:String,ID:String,view:UIView,imageData: NSData, videoData: NSData, isVideoRecorded:Bool,isoffline:String,uniqueno:String) {
        let notificationKey = "com.time-em.addTaskResponse"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "\(apiUrl)/usertask/AddUpdateUserTaskActivityNew", parameters:  ["ActivityId":ActivityId,"TaskId":TaskId,"UserId":UserId,"TaskName":TaskName,"TimeSpent":TimeSpent,"Comments":Comments,"CreatedDate":CreatedDate,"ID":ID])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        //                        print("\(JSON)")
                        if "\(JSON.valueForKey("Message")!)".rangeOfString("No Record Found !") != nil{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            return
                        }
                        
                        
                        
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
                MBProgressHUD.hideHUDForView(view, animated: true)
                
        }
        
    }
    
    func newSendnotificationWebservice(UserId:String,Subject:String,Message:String,NotificationTypeId:String,notifyto:String,view:UIView) {
        let notificationKey = "com.time-em.sendnotification"
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        let str:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("companyKey")!)" ;

        Alamofire.request(.POST, "\(apiUrl)/notification/AddNotificationNew", parameters:  ["UserId":UserId,"Subject":Subject,"Message":Message,"NotificationTypeId":NotificationTypeId,"notifyto":notifyto,"CompanyId":str])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        //                        print("\(JSON)")
                        if "\(JSON.valueForKey("Message")!)".rangeOfString("No Record Found !") != nil{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message")!)"]
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            return
                        }
                        
                        
                        
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
                MBProgressHUD.hideHUDForView(view, animated: true)
                
        }
        
    }
    
    func getUserCompaniesList(userId:String,view:UIView)  {
        let notificationKey = "com.time-em.getUserCompaniesList"
        MBProgressHUD.showHUDAddedTo(view, animated: true);
        Alamofire.request(.GET, "\(apiUrl)/User/GetUserCompaniesList", parameters: ["userId":userId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        
//                        if "\(JSON.valueForKey("isError")!.lowercaseString)".rangeOfString("0") != nil{
                            let userInfo = ["response" : "Success"]
                            
                            
                            let array:NSArray = (JSON as? NSArray)!
                            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(array)

                            NSUserDefaults.standardUserDefaults().setObject(encodedData, forKey: "companyData")
                            

                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
//                        }else{
//                            let userInfo = ["response" : "FAILURE"]
//                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
//                        }
                        
                        
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
    
    
    
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}








