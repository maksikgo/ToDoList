//
//  Task.swift
//  ToDoFIRE
//
//  Created by Maksim Halubko on 06.02.22.

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    let ref: FIRDatabaseReference?
    var completed: Bool = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["title": title, "userId": userId, "completed": completed]
    }
}
