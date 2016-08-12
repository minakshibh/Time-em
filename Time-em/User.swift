//
//  User.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 13/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class User: NSObject {
    
     var ActivityId:Int
     var Company:String = ""
     var CompanyId:Int
     var Department:String = ""
     var DepartmentId:Int
     var FirstName:String = ""
     var FullName:String = ""
     var Id:Int
     var IsSecurityPin:String = ""
     var IsSignIn:Int
     var LastName:String = ""
     var LoginCode:String = ""
     var LoginId:String = ""
     var NFCTagId:String = ""
     var Password:String = ""
     var Project:String = ""
     var ProjectId:Int
     var RefrenceCount:Int
     var ReturnMessage:String = ""
     var Supervisor:String = ""
     var SupervisorId:Int
     var Token:String = ""
     var UserType:String = ""
     var UserTypeId:Int
     var Worksite:String = ""
     var WorksiteId:Int
     var isError:Int
    var Email:String = ""
    var PhoneNumber:Int
    var Pin:String = ""
    
    required init(ActivityId: Int?, Company: String?, CompanyId: Int?, Department: String?, DepartmentId: Int?, FirstName: String?, FullName: String?, Id: Int?, IsSecurityPin: String?, IsSignIn: Int?, LastName: String?, LoginCode: String?, LoginId: String?, NFCTagId: String?, Password: String?, Project: String?,ProjectId: Int?, RefrenceCount: Int?,ReturnMessage: String? ,Supervisor: String? ,SupervisorId: Int? , Token: String? , UserType: String? = nil, UserTypeId: Int?, Worksite: String?,WorksiteId: Int?, isError: Int?, Email: String?, PhoneNumber: Int?, Pin: String?) {
        self.ActivityId = ActivityId!
        self.Company = Company ?? ""
        self.CompanyId = CompanyId!
        self.Department = Department ?? ""
        self.DepartmentId = DepartmentId!
        self.FirstName = FirstName ?? ""
        self.FullName = FullName ?? ""
        self.Id = Id!
        self.IsSecurityPin = IsSecurityPin ?? ""
        self.IsSignIn = IsSignIn!
        self.LastName = LastName ?? ""
        self.LoginCode = LoginCode ?? ""
        self.LoginId = LoginId ?? ""
        self.NFCTagId = NFCTagId ?? ""
        self.Project = Project ?? ""
        self.Password = Password ?? ""
        self.ProjectId = ProjectId!
        self.RefrenceCount = RefrenceCount!
        self.ReturnMessage = ReturnMessage ?? ""
        self.Supervisor = Supervisor ?? ""
        self.SupervisorId = SupervisorId!
        self.Token = Token ?? ""
        self.UserType = UserType ?? ""
        self.UserTypeId = UserTypeId!
        self.Worksite = Worksite ?? ""
        self.WorksiteId = WorksiteId!
        self.isError = isError!
         self.Email = Email ?? ""
        self.PhoneNumber = PhoneNumber!
        self.Pin = Pin ?? ""
    }
    
    convenience required init(dict: NSMutableDictionary) {
        self.init(ActivityId: dict["ActivityId"] as? Int,
                  Company: dict["Company"] as? String,
                  CompanyId: dict["CompanyId"] as? Int,
                  Department: dict["Department"] as? String,
                  DepartmentId: dict["DepartmentId"] as? Int,
                  FirstName: dict["FirstName"] as? String,
                  FullName: dict["FullName"] as? String,
                  Id: dict["Id"] as? Int,
                  IsSecurityPin: dict["IsSecurityPin"] as? String,
                  IsSignIn: dict["IsSignIn"] as? Int,
                  LastName: dict["LastName"] as? String ,
                  LoginCode: dict["LoginCode"] as? String,
                  LoginId: dict["LoginId"] as? String ,
                  NFCTagId: dict["NFCTagId"] as? String ,
                  Password : dict["Password"] as? String,
                  Project: dict["Project"] as? String,
                  
                  ProjectId : dict["ProjectId"] as? Int,
                  RefrenceCount : dict["RefrenceCount"] as? Int, ReturnMessage : dict["ReturnMessage"] as? String , Supervisor : dict["Supervisor"] as? String ,
                  SupervisorId : dict["SupervisorId"] as? Int ,
                  Token : dict["Token"] as? String ,
                  UserType : dict["UserType"] as? String,
                  UserTypeId : dict["UserTypeId"] as? Int,
                  Worksite : dict["Worksite"] as? String,
                  WorksiteId : dict["WorksiteId"] as? Int,
                  isError : dict["isError"] as? Int,
                  Email : dict["Email"] as? String,
                  PhoneNumber : dict["PhoneNumber"] as? Int,
                  Pin : dict["Pin"] as? String
        )
    }
    
     func returnDict() -> NSMutableDictionary {
        
        let data:NSMutableDictionary = [:]
        data.setObject(self.ActivityId, forKey: "ActivityId")
        data.setObject(self.Company, forKey: "Company")
        data.setObject(self.CompanyId, forKey: "CompanyId")
        data.setObject(self.Department, forKey: "Department")
        data.setObject(self.DepartmentId, forKey: "DepartmentId")
        data.setObject(self.FirstName, forKey: "FirstName")
        data.setObject(self.FullName, forKey: "FullName")
        data.setObject(self.Id, forKey: "Id")
        data.setObject(self.IsSecurityPin, forKey: "IsSecurityPin")
        data.setObject( self.IsSignIn, forKey: "IsSignIn")
        data.setObject(self.LastName, forKey: "LastName")
        data.setObject( self.LoginCode, forKey: "LoginCode")
        data.setObject(self.LoginId, forKey: "LoginId")
        data.setObject(self.NFCTagId, forKey: "NFCTagId")
        data.setObject(self.Project, forKey: "Project")
        data.setObject(self.Password, forKey: "Password")
        data.setObject(self.ProjectId, forKey: "ProjectId")
        data.setObject(self.RefrenceCount, forKey: "RefrenceCount")
        data.setObject(self.ReturnMessage, forKey: "ReturnMessage")
        data.setObject(self.Supervisor, forKey: "Supervisor")
        data.setObject(self.SupervisorId, forKey: "SupervisorId")
        data.setObject(self.Token , forKey: "Token")
        data.setObject(self.UserType, forKey: "UserType")
        data.setObject(self.UserTypeId, forKey: "UserTypeId")
        data.setObject(self.Worksite, forKey: "Worksite")
        data.setObject(self.WorksiteId, forKey: "WorksiteId")
        data.setObject(self.isError, forKey: "isError")
        data.setObject(self.Email, forKey: "Email")
        data.setObject(self.PhoneNumber, forKey: "PhoneNumber")
        data.setObject(self.Pin, forKey: "Pin")
        return data
    }

    
}
