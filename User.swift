//
//  User.swift
//  ToDoFIRE
//
//  Created by Maksim Halubko on 06.02.22.

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(user: FIRUser) {
        self.uid = user.uid
        self.email = user.email!
    }
}
