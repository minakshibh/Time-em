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
        var dataArray:NSMutableArray! = []
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
    
    
    func insertTeamData(dict:NSMutableDictionary)  {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
        }
        
        
        var teamIdsArr:NSMutableArray = []
        do {
            
            let rs = try database.executeQuery("select * from teamData", values: nil)
            while rs.next() {
                let x = rs.stringForColumn("SupervisorId")
                teamIdsArr.addObject(x)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        
        
        
        
        for (var i = 0; i<dict.count;i+=1){
            
            let  ActivityId:Int!
            if let field = dict.valueForKey("ActivityId")![i]  {
                ActivityId = field as! Int
            }else{
                ActivityId = 0
            }
            
            let  Company:String!
            if let field = dict.valueForKey("Company")![i]  as? String{
                Company = field as? String ?? ""
            }else{
                Company = ""
            }
            let  CompanyId:Int!
            if let field = dict.valueForKey("CompanyId")![i]  {
                CompanyId = field as! Int
            }else{
                CompanyId = 0
            }
            
            let  Department:String
            if let field = dict.valueForKey("Department")![i] as? String {
                Department = field
            }else{
                Department = ""
            }
            let  DepartmentId:Int!
            if let field = dict.valueForKey("DepartmentId")![i]  {
                DepartmentId = field as! Int
            }else{
                DepartmentId = 0
            }
            
            let  FirstName:String!
            if let field = dict.valueForKey("FirstName")![i] as? String {
                FirstName = field
            }else{
                FirstName = ""
            }
            
            let  FullName:String!
            if let field = dict.valueForKey("FullName")![i] as? String {
                FullName = field
            }else{
                FullName = ""
            }
            let  Id:Int!
            if let field = dict.valueForKey("Id")![i]  {
                Id = field as! Int
            }else{
                Id = 0
            }
            let  IsNightShift:Int!
            if let field = dict.valueForKey("IsNightShift")![i]  {
                IsNightShift = field as! Int
            }else{
                IsNightShift = 0
            }
            let  IsSecurityPin:String!
            if let field = dict.valueForKey("IsSecurityPin")![i] as? String {
                IsSecurityPin = field
            }else{
                IsSecurityPin = ""
            }
            let  IsSignedIn:Int!
            if let field = dict.valueForKey("IsSignedIn")![i]  {
                IsSignedIn = field as! Int
            }else{
                IsSignedIn = 0
            }
            let  LoginCode: Int!
            if let field = dict.valueForKey("LoginCode")![i]  {
                LoginCode = field as! Int
            }else{
                LoginCode = 0
            }
            
            let  LastName:String!
            if let field = dict.valueForKey("LastName")! [i]  as? String{
                LastName = field
            }else{
                LastName = ""
            }
            let  LoginId:String!
            if let field = dict.valueForKey("LoginId")! [i]  as? String{
                LoginId = field
            }else{
                LoginId = ""
            }

            let  NFCTagId:String!
            if let field = dict.valueForKey("NFCTagId")! [i]  as? String{
                NFCTagId = field
            }else{
                NFCTagId = ""
            }
            
            let  Project:String!
            if let field = dict.valueForKey("Project")![i] as? String  {
                Project = field
            }else{
                Project = ""
            }
            
            let  ProjectId:Int!
            if let field = dict.valueForKey("ProjectId")![i]  {
                ProjectId = field as! Int
            }else{
                ProjectId = 0
            }
            
            
            let  SignInAt :String!
            if let field = dict.valueForKey("SignInAt")![i] as? String {
                SignInAt = field
            }else{
                SignInAt = ""
            }
            
            let  SignOutAt:String!
            if let field = dict.valueForKey("SignOutAt")![i]  {
                SignOutAt = field as! String
            }else{
                SignOutAt = ""
            }
            
            
            
            let  SupervisorId: Int!
            if let field = dict.valueForKey("SupervisorId")![i]  {
                SupervisorId = field as! Int
            }else{
                SupervisorId = 0
            }
            
            
            let  SignedInHours: Int!
            if let field = dict.valueForKey("SignedInHours")![i]  {
                SignedInHours = field as! Int
            }else{
                SignedInHours = 0
            }
            
            let  TaskActivityId: Int!
            if let field = dict.valueForKey("TaskActivityId")![i]  {
                TaskActivityId = field as! Int
            }else{
                TaskActivityId = 0
            }
            
            let  UserTypeId: Int!
            if let field = dict.valueForKey("UserTypeId")![i]  {
                UserTypeId = field as! Int
            }else{
                UserTypeId = 0
            }
            
            let  WorksiteId: Int!
            if let field = dict.valueForKey("WorksiteId")![i]  {
                WorksiteId = field as! Int
            }else{
                WorksiteId = 0
            }
            
            let  Worksite:String!
            if let field = dict.valueForKey("Worksite")![i]  {
                Worksite = field as! String
            }else{
                Worksite = ""
            }
            
            
            if teamIdsArr.containsObject("\(SupervisorId!)") {
                do {
                    try database.executeUpdate("UPDATE teamData SET ActivityId ?, Company ?, CompanyId ? ,Department ?, DepartmentId ?, FirstName ?,FullName ?, Id ?, IsNightShift ?,IsSecurityPin ?, IsSignedIn ?, LastName ?,LoginCode ?, LoginId ?, NFCTagId ?, Project ? ,ProjectId ?, SignInAt ?, SignOutAt ?,SignedInHours ?,  TaskActivityId ?,UserTypeId ?, Worksite ?, WorksiteId ? WHERE SupervisorId=?", values: [ActivityId , Company , CompanyId ,Department , DepartmentId , FirstName ,FullName , Id , IsNightShift ,IsSecurityPin , IsSignedIn , LastName ,LoginCode , LoginId , NFCTagId , Project  ,ProjectId , SignInAt , SignOutAt ,SignedInHours ,  TaskActivityId ,UserTypeId , Worksite , WorksiteId,SupervisorId])
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
    
}
