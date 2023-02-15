//
//  User.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var email: String
    @Persisted var userID: String
    @Persisted var name: String
    
    convenience init(email: String, userID: String, name: String) {
        self.init()
        self.email = email
        self.userID = userID
        self.name = name
    }
}
