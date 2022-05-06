//
//  RealmController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 6.02.22.
//

import Foundation
import RealmSwift

class RealmManager {
    
    public let realm: Realm
    
    static let sharedInstance = RealmManager()
    private init() {
        realm = {
            let configuration = Realm.Configuration(schemaVersion: 3, migrationBlock: { migration, oldSchemaVersion in
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
                        new?["userID"] = "user=\(id)"
                    }
                }
            }, objectTypes: [Workout.self] )
            let realm = try! Realm(configuration: configuration)
            print(realm.configuration.fileURL?.path ?? "PATH IS NIL")
            return realm
        }()
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter isResultReversed: The boolean value using to distinguish wether we need to take reversed results
    /// - Returns: The array in the database for the given object type.
    func fetch(isResultReversed: Bool) -> [Workout] {
        if isResultReversed {
            let results = Array(realm.objects(Workout.self))
            return results.sorted(by: {$0.date > $1.date})
        } else {
            let results = Array(realm.objects(Workout.self))
            return results
        }
    }
    
    func saveData<T: Object>(object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
