//
//  RealmLocalConfig.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

extension Realm {
    static func localRealmConfig() -> Realm.Configuration {
        let localConfig = Realm.Configuration(schemaVersion: 3, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Workout.className()) { old, new in
                    new?["goalType"] = WorkoutGoal.openGoal
                }
            }
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: Workout.className()) {old, new in
                    new?["_id"] = ObjectId.generate()
                }
            }
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: Workout.className()) { old, new in
                    guard let id = app.currentUser?.id else {
                        // Here should be something different for ensure,
                        // That value userID will be the same as Sync Realm, but I have no idea
                        // How to achieve this
                        new?["userID"] = old?["_id"]
                        return
                    }
                    new?["userID"] = id
                }
            }
        }, objectTypes: [Workout.self] )
        
        return localConfig
    }
}
