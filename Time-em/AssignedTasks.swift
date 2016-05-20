//
//  AssignedTasks.swift
//  Time-em
//
//  Created by Krishna_Mac_4 on 19/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import Foundation

class AssignedTasks: NSObject {
    
    var  taskId:Int!
    var  taskName:String! = ""
    
    required init(taskId: Int?, taskName: String?) {
        self.taskId = taskId!
        self.taskName = taskName ?? ""
    }

convenience required init(dict: NSMutableDictionary) {
    self.init(taskId: dict["TaskId"] as? Int,
              taskName: dict["TaskName"] as? String
        
    )
}

func returnDict() -> NSMutableDictionary {
    
    let data:NSMutableDictionary = [:]
    data.setObject(self.taskId, forKey: "TaskId")
    data.setObject(self.taskName, forKey: "TaskName")
    return data
}
}