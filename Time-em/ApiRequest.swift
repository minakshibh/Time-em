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

class ApiRequest: NSObject {

    
    
    func loginApi(loginId:String,password:String,view:UIView) {
        let notificationKey = "com.time-em.loginResponse"
       
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
            let currentUsers =  User(dict: JSON as! NSMutableDictionary)
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
                try database.executeUpdate("create table tasksData(ActivityId text, AttachmentImageFile text, AttachmentVideoFile text ,Comments text, CreatedDate text, EndTime text,Id text, SelectedDate text, SignedInHours text,StartTime text, TaskId text, TaskName text,TimeSpent text, Token text, UserId text)", values: nil)
                try database.executeUpdate("create table teamData(ActivityId text, Company text, CompanyId text ,Department text, DepartmentId text, FirstName text,FullName text, Id text, IsNightShift text,IsSecurityPin text, IsSignedIn text, LastName text,LoginCode text, LoginId text, NFCTagId text, Project text ,ProjectId text, SignInAt text, SignOutAt text,SignedInHours text, SupervisorId text, TaskActivityId text,UserTypeId text, Worksite text, WorksiteId text)", values: nil)
                try database.executeUpdate("create table userdata(userId text, userData text, loggedInUser text)", values: nil)
                 try database.executeUpdate("insert into UserData (userId, userData, loggedInUser) values (?, ?, ?)", values: [currentUsers.LoginId, encodedData, "true"])
               
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
//        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/UserTask/GetUserActivityTask", parameters: ["userId":userId,"createdDate":createdDate])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    var message:String!
                    if JSON.valueForKey("Message") != nil {
                     message = "\(JSON.valueForKey("Message")!)"
                    }else{
                        let userInfo = ["response" : "Failure"]
                        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                    }
                    
                    
                    if message.lowercaseString == "success"{
                        
                        NSUserDefaults.standardUserDefaults().setObject(JSON.valueForKey("TimeStamp"), forKey: "TimeStamp")
                        let dict = JSON.valueForKey("UserTaskActivityViewModel") as! NSArray
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
            if let field = dict.valueForKey("ActivityId")[i]  {
                                    ActivityId = field as! Int
            }else{
                ActivityId = 0
            }
                            
            let  AttachmentImageFile:String!
            if let field = dict.valueForKey("AttachmentImageFile")[i]  as? String{
                AttachmentImageFile = field as? String ?? ""
            }else{
                AttachmentImageFile = ""
            }
                                
            let  AttachmentVideoFile:String
            if let field = dict.valueForKey("AttachmentVideoFile")[i] as? String {
                AttachmentVideoFile = field
            }else{
                AttachmentVideoFile = ""
            }
                                
            let  Comments:String!
            if let field = dict.valueForKey("Comments")[i] as? String {
                Comments = field
            }else{
                Comments = ""
            }
                                
            let  CreatedDate:String!
            if let field = dict.valueForKey("CreatedDate")[i] as? String {
                CreatedDate = field
            }else{
                CreatedDate = ""
            }
                                
            let  EndTime:String!
            if let field = dict.valueForKey("EndTime")[i] as? String {
                EndTime = field
            }else{
                EndTime = ""
            }
                                
            let  Id: Int!
            if let field = dict.valueForKey("Id")[i]  {
                Id = field as! Int
            }else{
                Id = 0
            }
                                
            let  SelectedDate:String!
            if let field = dict.valueForKey("SelectedDate") [i]  as? String{
                SelectedDate = field
            }else{
                SelectedDate = ""
            }
                                
            let  SignedInHours: Int!
            if let field = dict.valueForKey("SignedInHours")[i]  {
                SignedInHours = field as! Int
            }else{
                SignedInHours = 0
            }
                                
            let  StartTime:String!
            if let field = dict.valueForKey("StartTime")[i] as? String  {
                StartTime = field
            }else{
                StartTime = ""
            }
                                
            let  TaskId:Int!
            if let field = dict.valueForKey("TaskId")[i]  {
                TaskId = field as! Int
            }else{
                TaskId = 0
            }
                                
                                
                                let  TaskName :String!
            if let field = dict.valueForKey("TaskName")[i] as? String {
                TaskName = field
            }else{
                TaskName = ""
            }
                                
            let  TimeSpent:Float!
            if let field = dict.valueForKey("TimeSpent")[i]  {
                TimeSpent = field as! Float
            }else{
                TimeSpent = 0
            }
                                
                                
            let  Token: String!
            if let field = dict.valueForKey("Token")[i] as? String {
                Token = field
            }else{
                Token = ""
            }
                                
                                
            let  UserId: Int!
            if let field = dict.valueForKey("UserId")[i]  {
                UserId = field as! Int
            }else{
                UserId = 0
            }
                
                
            if TaskIdsArr.containsObject("\(Id!)") {
                do {
                try database.executeUpdate("UPDATE tasksData SET ActivityId = ? , AttachmentImageFile = ? , AttachmentVideoFile = ?  ,Comments = ? , CreatedDate = ? , EndTime  = ?, SelectedDate  = ?, SignedInHours = ?,StartTime = ? , TaskId = ? , TaskName = ? ,TimeSpent = ? , Token = ? , UserId = ? WHERE Id=?", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId , Id])
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
                
            }else{

                do {
//                    try database.executeUpdate("delete * from  tasksData", values: nil)
                    try database.executeUpdate("insert into tasksData (ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId ) values (?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?)", values: [ActivityId , AttachmentImageFile , AttachmentVideoFile  ,Comments , CreatedDate , EndTime ,Id , SelectedDate , SignedInHours ,StartTime , TaskId , TaskName ,TimeSpent , Token , UserId ])

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
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net/api/UserActivity/SignOutByLoginId", parameters: ["userId":userId,"LoginId":LoginId,"ActivityId":ActivityId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                       
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("successfully") != nil {
                             let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
                            
                            
                            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                            
                            let database = FMDatabase(path: fileURL.path)
                            
                            if !database.open() {
                                print("Unable to open database")
                                return
                            }
                            var encodedData:NSData!
                            var currentUserId:String!
                            do {
                                
                                let rs = try database.executeQuery("select * from userdata", values: nil)
                                while rs.next() {
                                     currentUserId = rs.stringForColumn("userId")
                                    let y = rs.dataForColumn("userData")
                                    let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(y) as! NSMutableDictionary
                                    userDict.setValue(0, forKey: "IsSignIn")
                                     encodedData = NSKeyedArchiver.archivedDataWithRootObject(userDict)
                                }
                            } catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            database.close()
                            
                            if !database.open() {
                                print("Unable to open database")
                                return
                            }
//                            userdata(userId text, userData text, loggedInUser text)
                            do {
                                try database.executeUpdate("UPDATE userdata SET userData = ? WHERE userId=?", values: [encodedData,currentUserId])
                            } catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            
                            database.close()
                            
                            
                            
                             NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                            
                            
                        }else{
                             let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
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
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.POST, "http://timeemapi.azurewebsites.net//api/UserActivity/SignInByLoginId", parameters: ["userId":userId,"LoginId":LoginId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if "\(response.result)" == "SUCCESS"{
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("successfully") != nil{

                            let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
                            
                            
                            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
                            
                            let database = FMDatabase(path: fileURL.path)
                            
                            if !database.open() {
                                print("Unable to open database")
                                return
                            }
                            var encodedData:NSData!
                            var currentUserId:String!
                            do {
                                
                                let rs = try database.executeQuery("select * from userdata", values: nil)
                                while rs.next() {
                                    currentUserId = rs.stringForColumn("userId")
                                    let y = rs.dataForColumn("userData")
                                    let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(y) as! NSMutableDictionary
                                    userDict.setValue(1, forKey: "IsSignIn")
                                    encodedData = NSKeyedArchiver.archivedDataWithRootObject(userDict)
                                }
                            } catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            database.close()
                            
                            if !database.open() {
                                print("Unable to open database")
                                return
                            }
                            //                            userdata(userId text, userData text, loggedInUser text)
                            do {
                                try database.executeUpdate("UPDATE userdata SET userData = ? WHERE userId=?", values: [encodedData,currentUserId])
                            } catch let error as NSError {
                                print("failed: \(error.localizedDescription)")
                            }
                            
                            database.close()
                            

                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
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
                            return
                        }
                        
                        if "\(JSON.valueForKey("Message")!.lowercaseString)".rangeOfString("success") != nil{
                            
                            let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
                            NSUserDefaults.standardUserDefaults().setObject(JSON.valueForKey("TimeStamp"), forKey: "teamTimeStamp")
                            let dict = JSON.valueForKey("AppUserViewModel") as! NSArray
                          
                            
                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil, userInfo: userInfo)
                            
                        }else{
                            let userInfo = ["response" : "\(JSON.valueForKey("Message"))"]
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
    //                        let user = NSUserDefaults.standardUserDefaults()
    //                        user.setObject("\(JSON.valueForKey("ActivityId") ?? "")", forKey: "ActivityId")
    //                        user.setObject("\(JSON.valueForKey("Company") ?? "")", forKey: "Company")
    //                        user.setObject("\(JSON.valueForKey("CompanyId") ?? "")", forKey: "CompanyId")
    //                        user.setObject("\(JSON.valueForKey("Department") ?? "")", forKey: "Department")
    //                        user.setObject("\(JSON.valueForKey("DepartmentId") ?? "")", forKey: "DepartmentId")
    //                        user.setObject("\(JSON.valueForKey("FirstName") ?? "")", forKey: "FirstName")
    //                        user.setObject("\(JSON.valueForKey("FullName") ?? "")", forKey: "FullName")
    //                        user.setObject("\(JSON.valueForKey("Id") ?? "")", forKey: "Id")
    //                        user.setObject("\(JSON.valueForKey("IsSecurityPin") ?? "")", forKey: "IsSecurityPin")
    //                        user.setObject("\(JSON.valueForKey("IsSignIn") ?? "")", forKey: "IsSignIn")
    //                        user.setObject("\(JSON.valueForKey("LastName") ?? "")", forKey: "LastName")
    //                        user.setObject("\(JSON.valueForKey("LoginCode") ?? "")", forKey: "LoginCode")
    //                        user.setObject("\(JSON.valueForKey("LoginId") ?? "")", forKey: "LoginId")
    //                        user.setObject("\(JSON.valueForKey("NFCTagId") ?? "")", forKey: "NFCTagId")
    //                        user.setObject("\(JSON.valueForKey("Password") ?? "")", forKey: "Password")
    //                        user.setObject("\(JSON.valueForKey("Project") ?? "")", forKey: "Project")
    //                        user.setObject("\(JSON.valueForKey("ProjectId") ?? "")", forKey: "ProjectId")
    //                        user.setObject("\(JSON.valueForKey("RefrenceCount") ?? "")", forKey: "RefrenceCount")
    //                        user.setObject("\(JSON.valueForKey("ReturnMessage") ?? "")", forKey: "ReturnMessage")
    //                        user.setObject("\(JSON.valueForKey("Supervisor") ?? "")", forKey: "Supervisor")
    //                        user.setObject("\(JSON.valueForKey("SupervisorId") ?? "")", forKey: "SupervisorId")
    //                        user.setObject("\(JSON.valueForKey("Token") ?? "")", forKey: "Token")
    //                        user.setObject("\(JSON.valueForKey("UserType") ?? "")", forKey: "UserType")
    //                        user.setObject("\(JSON.valueForKey("UserTypeId") ?? "")", forKey: "UserTypeId")
    //                        user.setObject("\(JSON.valueForKey("Worksite") ?? "")", forKey: "Worksite")
    //                        user.setObject("\(JSON.valueForKey("WorksiteId") ?? "")", forKey: "WorksiteId")
    //                        user.setObject("\(JSON.valueForKey("isError") ?? "")", forKey: "isError")
    
    
    
    
    
    
    
}
    
    
    
    
    
    
    
    
    
    

