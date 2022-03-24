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
            let realm = try! Realm(configuration: Realm.Configuration(objectTypes:[Workout.self]))
//            print(realm.configuration.fileURL?.path ?? "PATH IS NIL")
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
