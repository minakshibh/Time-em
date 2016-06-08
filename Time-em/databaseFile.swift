//
//  databaseFile.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 18/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import FMDB

class databaseFile: NSObject {
    
    // try database.executeUpdate("create table notificationActiveUserList(userid text, FullName text)", values: nil)
    
    func getTeamDetail(loginCode:String) -> NSMutableDictionary{
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        let dict: NSMutableDictionary = [:]
        do {
            let rs = try database.executeQuery("select * from teamData where LoginCode = ?", values: [loginCode])
            while rs.next() {
            
                
                dict.setObject(rs.stringForColumn("ActivityId"), forKey: "ActivityId")
                dict.setObject(rs.stringForColumn("Company"), forKey: "Company")
                dict.setObject(rs.stringForColumn("CompanyId"), forKey: "CompanyId")
                dict.setObject(rs.stringForColumn("Department"), forKey: "Department")
                dict.setObject(rs.stringForColumn("DepartmentId"), forKey: "DepartmentId")
                dict.setObject(rs.stringForColumn("FirstName"), forKey: "FirstName")
                dict.setObject(rs.stringForColumn("FullName"), forKey: "FullName")
                dict.setObject(rs.stringForColumn("Id"), forKey: "Id")
                dict.setObject(rs.stringForColumn("IsNightShift"), forKey: "IsNightShift")
                dict.setObject(rs.stringForColumn("IsSecurityPin"), forKey: "IsSecurityPin")
                dict.setObject(rs.stringForColumn("IsSignedIn"), forKey: "IsSignedIn")
                dict.setObject(rs.stringForColumn("LastName"), forKey: "LastName")
                dict.setObject(rs.stringForColumn("LoginCode"), forKey: "LoginCode")
                dict.setObject(rs.stringForColumn("LoginId"), forKey: "LoginId")
                dict.setObject(rs.stringForColumn("Project"), forKey: "Project")
                
                dict.setObject(rs.stringForColumn("SignInAt"), forKey: "SignInAt")
                dict.setObject(rs.stringForColumn("SignOutAt"), forKey: "SignOutAt")
                dict.setObject(rs.stringForColumn("SignedInHours"), forKey: "SignedInHours")
                dict.setObject(rs.stringForColumn("SupervisorId"), forKey: "SupervisorId")
                dict.setObject(rs.stringForColumn("TaskActivityId"), forKey: "TaskActivityId")
                
                dict.setObject(rs.stringForColumn("UserTypeId"), forKey: "UserTypeId")
                dict.setObject(rs.stringForColumn("Worksite"), forKey: "Worksite")
                dict.setObject(rs.stringForColumn("WorksiteId"), forKey: "WorksiteId")
                dict.setObject(rs.stringForColumn("ID"), forKey: "ID")
                
            database.close()   
            return dict
            }
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        return dict
        
    }
    func getImageForUrl(url:String,imageORvideo:String) -> NSMutableArray{
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        var data:NSData!
        do {
            let rs = try database.executeQuery("select * from tasksData where \(imageORvideo) = ?", values: [url])
            while rs.next() {
              data = rs.dataForColumn("AttachmentImageData")
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        let dataarrr:NSMutableArray = []
        dataarrr.addObject(data ?? "")
        database.close()
        return dataarrr
    }
    
    
    func addImageToTask (AttachmentImageFile:String,AttachmentImageData:NSData,imageORvideo:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        
        do {
            try database.executeUpdate("UPDATE tasksData SET AttachmentImageData = ? WHERE \(imageORvideo)=?", values: [AttachmentImageData, AttachmentImageFile])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
    }
    

    func getTasksForUserID(ID:String,Date:String) -> NSMutableArray {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        let dataArray:NSMutableArray! = []
        let str = "\(Date.componentsSeparatedByString("-")[1])/\(Date.componentsSeparatedByString("-")[0])/\(Date.componentsSeparatedByString("-")[2])"
        do {
            let rs = try database.executeQuery("select * from tasksData", values: nil)
            while rs.next() {
                let dict: NSMutableDictionary = [:]
                dict.setObject(rs.stringForColumn("ActivityId"), forKey: "ActivityId")
                dict.setObject(rs.stringForColumn("AttachmentImageFile"), forKey: "AttachmentImageFile")
                dict.setObject(rs.stringForColumn("AttachmentVideoFile"), forKey: "AttachmentVideoFile")
                dict.setObject(rs.stringForColumn("CreatedDate"), forKey: "CreatedDate")
                dict.setObject(rs.stringForColumn("EndTime"), forKey: "EndTime")
                dict.setObject(rs.stringForColumn("SelectedDate"), forKey: "SelectedDate")
                dict.setObject(rs.stringForColumn("SignedInHours"), forKey: "SignedInHours")
                dict.setObject(rs.stringForColumn("StartTime"), forKey: "StartTime")
                dict.setObject(rs.stringForColumn("TaskId"), forKey: "TaskId")
                dict.setObject(rs.stringForColumn("TaskName"), forKey: "TaskName")
                dict.setObject(rs.stringForColumn("TimeSpent"), forKey: "TimeSpent")
                dict.setObject(rs.stringForColumn("Token"), forKey: "Token")
                dict.setObject(rs.stringForColumn("UserId"), forKey: "UserId")
                dict.setObject(rs.stringForColumn("Id"), forKey: "Id")
                dict.setObject(rs.stringForColumn("Comments"), forKey: "Comments")
//                dict.setObject(rs.stringForColumn("AttachmentImageData") ?? "", forKey: "AttachmentImageData")

//                print(rs.stringForColumn("UserId"))
                if rs.stringForColumn("UserId") == ID  && rs.stringForColumn("CreatedDate")!.componentsSeparatedByString(" ")[0] == str {
                dataArray.addObject(dict)
                }
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        return dataArray
    }
    
    func getAssignedTasks() -> NSMutableArray {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        let dataArray:NSMutableArray! = []
        do {
            let rs = try database.executeQuery("select * from assignedTaskList", values: nil)
            while rs.next() {
                let dict: NSMutableDictionary = [:]
                dict.setObject(rs.stringForColumn("TaskId"), forKey: "taskId")
                dict.setObject(rs.stringForColumn("TaskName"), forKey: "taskName")
                dataArray.addObject(dict)
                }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        return dataArray
    }
    
    func getTeamForUserID(ID:String) -> NSMutableArray {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        let dataArray:NSMutableArray! = []
        do {
            let rs = try database.executeQuery("select * from teamData", values: nil)
            while rs.next() {
                let dict: NSMutableDictionary = [:]
                dict.setObject(rs.stringForColumn("ActivityId"), forKey: "ActivityId")
                dict.setObject(rs.stringForColumn("Company"), forKey: "Company")
                dict.setObject(rs.stringForColumn("CompanyId"), forKey: "CompanyId")
                dict.setObject(rs.stringForColumn("Department"), forKey: "Department")
                dict.setObject(rs.stringForColumn("DepartmentId"), forKey: "DepartmentId")
                dict.setObject(rs.stringForColumn("FirstName"), forKey: "FirstName")
                dict.setObject(rs.stringForColumn("FullName"), forKey: "FullName")
                dict.setObject(rs.stringForColumn("Id"), forKey: "Id")
                dict.setObject(rs.stringForColumn("IsNightShift"), forKey: "IsNightShift")
                dict.setObject(rs.stringForColumn("IsSecurityPin"), forKey: "IsSecurityPin")
                dict.setObject(rs.stringForColumn("IsSignedIn"), forKey: "IsSignedIn")
                dict.setObject(rs.stringForColumn("LastName"), forKey: "LastName")
                dict.setObject(rs.stringForColumn("LoginCode"), forKey: "LoginCode")
                dict.setObject(rs.stringForColumn("LoginId"), forKey: "LoginId")
                dict.setObject(rs.stringForColumn("Project"), forKey: "Project")
                
                dict.setObject(rs.stringForColumn("SignInAt"), forKey: "SignInAt")
                dict.setObject(rs.stringForColumn("SignOutAt"), forKey: "SignOutAt")
                dict.setObject(rs.stringForColumn("SignedInHours"), forKey: "SignedInHours")
                dict.setObject(rs.stringForColumn("SupervisorId"), forKey: "SupervisorId")
                dict.setObject(rs.stringForColumn("TaskActivityId"), forKey: "TaskActivityId")
                
                dict.setObject(rs.stringForColumn("UserTypeId"), forKey: "UserTypeId")
                dict.setObject(rs.stringForColumn("Worksite"), forKey: "Worksite")
                dict.setObject(rs.stringForColumn("WorksiteId"), forKey: "WorksiteId")
                
//                print(rs.stringForColumn("SupervisorId"))
                if rs.stringForColumn("SupervisorId") == ID {
                    dataArray.addObject(dict)
                }
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        return dataArray
    }
    
    
    func insertTeamData(dataArr:NSArray)  {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        
        
        let teamIdsArr:NSMutableArray = []
        do {
            
            let rs = try database.executeQuery("select * from teamData", values: nil)
            while rs.next() {
                let x = rs.stringForColumn("Id")
                teamIdsArr.addObject(x)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        
        
        
        
        for (var i = 0; i<dataArr.count;i+=1){
            let dict = dataArr[i]
            
            let  ActivityId:Int!
            if let field = dict.valueForKey("ActivityId")  {
                ActivityId = field as! Int
            }else{
                ActivityId = 0
            }
            
            let  Company:String!
            if let field = dict.valueForKey("Company") as? String{
                Company = field as? String ?? ""
            }else{
                Company = ""
            }
            let  CompanyId:Int!
            if let field = dict.valueForKey("CompanyId")  {
                CompanyId = field as! Int
            }else{
                CompanyId = 0
            }
            
            let  Department:String
            if let field = dict.valueForKey("Department") as? String {
                Department = field
            }else{
                Department = ""
            }
            let  DepartmentId:Int!
            if let field = dict.valueForKey("DepartmentId")  {
                DepartmentId = field as! Int
            }else{
                DepartmentId = 0
            }
            
            let  FirstName:String!
            if let field = dict.valueForKey("FirstName") as? String {
                FirstName = field
            }else{
                FirstName = ""
            }
            
            let  FullName:String!
            if let field = dict.valueForKey("FullName") as? String {
                FullName = field
            }else{
                FullName = ""
            }
            let  Id:Int!
            if let field = dict.valueForKey("Id")  {
                Id = field as! Int
            }else{
                Id = 0
            }
            let  IsNightShift:Int!
            if let field = dict.valueForKey("IsNightShift")  {
                IsNightShift = field as! Int
            }else{
                IsNightShift = 0
            }
            let  IsSecurityPin:String!
            if let field = dict.valueForKey("IsSecurityPin") as? String {
                IsSecurityPin = field
            }else{
                IsSecurityPin = ""
            }
            let  IsSignedIn:Int!
            if let field = dict.valueForKey("IsSignedIn")  {
                IsSignedIn = field as! Int
            }else{
                IsSignedIn = 0
            }
            let  LoginCode: String!
            if let field = dict.valueForKey("LoginCode") as? String  {
                LoginCode = field
            }else{
                LoginCode = ""
            }
            
            let  LastName:String!
            if let field = dict.valueForKey("LastName")  as? String{
                LastName = field
            }else{
                LastName = ""
            }
            let  LoginId:String!
            if let field = dict.valueForKey("LoginId")  as? String{
                LoginId = field
            }else{
                LoginId = ""
            }

            let  NFCTagId:String!
            if let field = dict.valueForKey("NFCTagId")  as? String{
                NFCTagId = field
            }else{
                NFCTagId = ""
            }
            
            let  Project:String!
            if let field = dict.valueForKey("Project") as? String  {
                Project = field
            }else{
                Project = ""
            }
            
            let  ProjectId:Int!
            if let field = dict.valueForKey("ProjectId")  {
                ProjectId = field as! Int
            }else{
                ProjectId = 0
            }
            
            
            let  SignInAt :String!
            if let field = dict.valueForKey("SignInAt") as? String {
                SignInAt = field
            }else{
                SignInAt = ""
            }
            
            let  SignOutAt:String!
            if let field = dict.valueForKey("SignOutAt") as? String{
                SignOutAt = field 
            }else{
                SignOutAt = ""
            }
            
            
            
            let  SupervisorId: Int!
            if let field = dict.valueForKey("SupervisorId")  {
                SupervisorId = field as! Int
            }else{
                SupervisorId = 0
            }
            
            
            let  SignedInHours: Int!
            if let field = dict.valueForKey("SignedInHours")  {
                SignedInHours = field as! Int
            }else{
                SignedInHours = 0
            }
            
            let  TaskActivityId: Int!
            if let field = dict.valueForKey("TaskActivityId")  {
                TaskActivityId = field as! Int
            }else{
                TaskActivityId = 0
            }
            
            let  UserTypeId: Int!
            if let field = dict.valueForKey("UserTypeId")  {
                UserTypeId = field as! Int
            }else{
                UserTypeId = 0
            }
            
            let  WorksiteId: Int!
            if let field = dict.valueForKey("WorksiteId")  {
                WorksiteId = field as! Int
            }else{
                WorksiteId = 0
            }
            
            let  Worksite:String!
            if let field = dict.valueForKey("Worksite") as? String {
                Worksite = field as! String
            }else{
                Worksite = ""
            }
            
            
            if teamIdsArr.containsObject("\(Id!)") {
                do {
                    try database.executeUpdate("UPDATE teamData SET ActivityId=?, Company=?, CompanyId=? ,Department=?, DepartmentId=?, FirstName=?,FullName=?, SupervisorId=?, IsNightShift=?,IsSecurityPin=?, IsSignedIn=?, LastName=?,LoginCode=?, LoginId=?, NFCTagId=?, Project=? ,ProjectId=?, SignInAt=?, SignOutAt=?,SignedInHours=?,  TaskActivityId=?,UserTypeId=?, Worksite=?, WorksiteId=? WHERE Id=?", values: [ActivityId , Company , CompanyId ,Department , DepartmentId , FirstName ,FullName , SupervisorId , IsNightShift ,IsSecurityPin , IsSignedIn , LastName ,LoginCode , LoginId , NFCTagId , Project  ,ProjectId , SignInAt , SignOutAt ,SignedInHours ,  TaskActivityId ,UserTypeId , Worksite , WorksiteId,Id])
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
                
            }else{
                
                do {
                    //                    try database.executeUpdate("delete * from  tasksData", values: nil)
                    try database.executeUpdate("insert into teamData (ActivityId , Company , CompanyId  ,Department , DepartmentId , FirstName ,FullName , Id , IsNightShift ,IsSecurityPin , IsSignedIn , LastName ,LoginCode , LoginId , NFCTagId , Project  ,ProjectId , SignInAt , SignOutAt , SignedInHours ,  TaskActivityId ,UserTypeId , Worksite , WorksiteId , SupervisorId) values (?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?,?, ?, ?,?, ?,?, ?, ?)", values: [ActivityId , Company , CompanyId  ,Department , DepartmentId , FirstName ,FullName , Id , IsNightShift ,IsSecurityPin , IsSignedIn , LastName ,LoginCode , LoginId , NFCTagId , Project  ,ProjectId , SignInAt , SignOutAt , SignedInHours ,  TaskActivityId ,UserTypeId , Worksite , WorksiteId , SupervisorId])
                    
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
            }
            
        }
        database.close()
    }
    
    func insertAssignedListData(dataArr:NSArray)  {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        
        
        let teamIdsArr:NSMutableArray = []
        do {
            
            let rs = try database.executeQuery("select * from assignedTaskList", values: nil)
            while rs.next() {
                let x = "\(rs.stringForColumn("TaskId")!)"
//                print(x)
                teamIdsArr.addObject(x)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
         for i in 0 ..< dataArr.count {
            let dict:NSMutableDictionary! = dataArr[i] as? NSMutableDictionary
            
            let  TaskId:Int!
            if let field = dict.valueForKey("TaskId")  {
                TaskId = field as! Int
            }else{
                TaskId = 0
            }
            
            let  TaskName:String!
            if let field = dict.valueForKey("TaskName") as? String{
                TaskName = field as? String ?? ""
            }else{
                TaskName = ""
            }
            
            if teamIdsArr.containsObject("\(TaskId!)") {
                do {
                    try database.executeUpdate("UPDATE assignedTaskList SET  TaskName=? where TaskId=?,", values: [  TaskName,TaskId])
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
                
            }else{
                
                do {
                    //                    try database.executeUpdate("delete * from  tasksData", values: nil)
                    try database.executeUpdate("insert into assignedTaskList (TaskId , TaskName ) values (?, ?)", values: [TaskId , TaskName])
                    
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
            }
            
        }
        database.close()
    }
    
    func teamSignInUpdate (userId:String) {
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
            try database.executeUpdate("UPDATE teamData SET IsSignedIn=? WHERE Id=?", values: ["1", userId])
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    
    func teamSignOutUpdate (userId:String,SignInAt:String,SignOutAt:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("UPDATE teamData SET IsSignedIn=?, SignInAt=?, SignOutAt=? WHERE Id=?", values: ["0",SignInAt,SignOutAt, userId])
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
               
        
    }
    
    func signOutUpdate (userId:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("UPDATE teamData SET IsSignedIn=? WHERE Id=?", values: ["0"])
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        
        
    }


    
    func updateActivityIdForTeam (userid:String,activityId:String,SignInAt:String){
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }

        do {
            try database.executeUpdate("UPDATE teamData SET ActivityId=?,IsSignedIn=?,SignInAt=? WHERE Id=?", values: [activityId,"1",SignInAt,userid])
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }

    }
    
    func deleteTask(id:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("delete  from  tasksData WHERE Id=?", values: [id])            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    
    func addDataToSync(type:String,data:NSMutableArray)  {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data)
        
        do {
            try database.executeUpdate("insert into sync (type , data) values (?, ?)", values: [type , encodedData])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    
    func getDataFromSync() -> NSMutableDictionary  {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        let dict:NSMutableDictionary = [:]
        do {
            let rs = try database.executeQuery("select * from sync", values: nil)
            while rs.next() {
               let x =  rs.stringForColumn("type")
               let y =  rs.dataForColumn("data")
                let userArr:NSMutableArray = NSKeyedUnarchiver.unarchiveObjectWithData(y) as! NSMutableArray
                
                dict.setObject(userArr, forKey: x)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        return dict
    }
   
    func currentUserSignOut(array:NSArray)  {
    
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
                
                let dicton = array[0] as? NSDictionary
                print("\(dicton?.valueForKey("SignInAt"))")
                userDict.setValue(dicton?.valueForKey("SignInAt")!, forKey: "SignInAt")
                userDict.setValue(dicton?.valueForKey("SignOutAt")!, forKey: "SignOutAt")
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
    }
    
       func currentUserSignIn(arr:NSArray)  {
        
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
                let val:NSDictionary = (arr[0] as? NSDictionary)!
                print(val.valueForKey("Id"))
                
                userDict.setValue("\(val.valueForKey("Id")!)", forKey: "ActivityId")
                NSUserDefaults.standardUserDefaults().setObject("\(val.valueForKey("Id")!)", forKey: "currentUser_ActivityId")
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
    }
    
    func currentUserSignOutSync()  {
        
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
        do {
            try database.executeUpdate("UPDATE userdata SET userData = ? WHERE userId=?", values: [encodedData,currentUserId])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }

    func currentUserSignInSync()  {
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
        do {
            try database.executeUpdate("UPDATE userdata SET userData = ? WHERE userId=?", values: [encodedData,currentUserId])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    
    func saveNotificationType(data:NSArray) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        let userDict = NSKeyedArchiver.archivedDataWithRootObject(data)
        do {
            try database.executeUpdate("delete from  notificationtype", values: nil)
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        do {
            try database.executeUpdate("insert into notificationtype (data) values (?)", values: [userDict])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    func getNotificationType() -> NSArray{
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        var userARR:NSArray = []
        do {
            let rs = try database.executeQuery("select * from notificationtype", values: nil)

            while rs.next() {
             let x = rs.dataForColumn("data")
                 userARR = NSKeyedUnarchiver.unarchiveObjectWithData(x) as! NSArray

            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
            userARR = []
        }
        database.close()
        return userARR

    }

    func saveNotificationActiveUserList(FullName:String,userid:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            try database.executeUpdate("insert into notificationActiveUserList (userid,FullName) values (?,?)", values: [userid,FullName])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }

    func getNotificationActiveUserList() -> NSMutableArray{
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        var userARR:NSMutableArray = []
        do {
            let rs = try database.executeQuery("select * from notificationActiveUserList", values: nil)
            
            while rs.next() {
                let dict:NSMutableDictionary = [:]
                let x = rs.stringForColumn("userid")
                let y = rs.stringForColumn("FullName")
                dict.setValue(x, forKey: "userid")
                dict.setValue(y, forKey: "FullName")
                userARR.addObject(dict)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
            userARR = []
        }
        database.close()
        return userARR
        
    }
    
    
    func saveNotifications(AttachmentFullPath:String,Message:String,NotificationId:String,NotificationTypeName:String,SenderFullName:String,Senderid:String,Subject:String,createdDate:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            try database.executeUpdate("insert into notificationsTable(AttachmentFullPath,Message,NotificationId,NotificationTypeName,SenderFullName,Senderid,Subject,createdDate) values (?,?,?,?,?,?,?,?)", values: [AttachmentFullPath,Message,NotificationId,NotificationTypeName,SenderFullName,Senderid,Subject,createdDate])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    
    func getNotifications() -> NSMutableArray{
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        var userARR:NSMutableArray = []
        do {
            let rs = try database.executeQuery("select * from notificationsTable", values: nil)
            
            while rs.next() {
                let dict:NSMutableDictionary = [:]
                let AttachmentFullPath = rs.stringForColumn("AttachmentFullPath")
                let Message = rs.stringForColumn("Message")
                let NotificationId = rs.stringForColumn("NotificationId")
                let NotificationTypeName = rs.stringForColumn("NotificationTypeName")
                let SenderFullName = rs.stringForColumn("SenderFullName")
                let Senderid = rs.stringForColumn("Senderid")
                let Subject = rs.stringForColumn("Subject")
                let createdDate = rs.stringForColumn("createdDate")
                
                dict.setValue(AttachmentFullPath, forKey: "AttachmentFullPath")
                dict.setValue(Message, forKey: "Message")
                dict.setValue(NotificationId, forKey: "NotificationId")
                dict.setValue(NotificationTypeName, forKey: "NotificationTypeName")
                dict.setValue(SenderFullName, forKey: "SenderFullName")
                dict.setValue(Senderid, forKey: "Senderid")
                dict.setValue(Subject, forKey: "Subject")
                dict.setValue(createdDate, forKey: "createdDate")
                userARR.addObject(dict)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
            userARR = []
        }
        database.close()
        return userARR
        
    }
    func deleteNotification(id:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("delete  from  notificationsTable WHERE NotificationId=?", values: [id])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    
    func deleteTaskFromDatabse(id:String) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("delete  from  tasksData WHERE TaskId=?", values: [id])
        } catch let error as NSError {
            print("### failed: \(error.localizedDescription)")
        }
        database.close()
    }
}

