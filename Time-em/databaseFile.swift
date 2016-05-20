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
    
    func getTasksForUserID(ID:String) -> NSMutableArray {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        let dataArray:NSMutableArray! = []
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
                print(rs.stringForColumn("UserId"))
                if rs.stringForColumn("UserId") == ID {
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
                
                print(rs.stringForColumn("SupervisorId"))
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
                    try database.executeUpdate("UPDATE teamData SET ActivityId ?, Company ?, CompanyId ? ,Department ?, DepartmentId ?, FirstName ?,FullName ?, SupervisorId ?, IsNightShift ?,IsSecurityPin ?, IsSignedIn ?, LastName ?,LoginCode ?, LoginId ?, NFCTagId ?, Project ? ,ProjectId ?, SignInAt ?, SignOutAt ?,SignedInHours ?,  TaskActivityId ?,UserTypeId ?, Worksite ?, WorksiteId ? WHERE Id=?", values: [ActivityId , Company , CompanyId ,Department , DepartmentId , FirstName ,FullName , SupervisorId , IsNightShift ,IsSecurityPin , IsSignedIn , LastName ,LoginCode , LoginId , NFCTagId , Project  ,ProjectId , SignInAt , SignOutAt ,SignedInHours ,  TaskActivityId ,UserTypeId , Worksite , WorksiteId,Id])
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
                let x = rs.stringForColumn("TaskId")
                teamIdsArr.addObject(x)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
         for i in 0 ..< dataArr.count {
            let dict = dataArr[i]
            
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
                    try database.executeUpdate("UPDATE assignedTaskList SET TaskId ?, TaskName ?", values: [TaskId , TaskName])
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
}
