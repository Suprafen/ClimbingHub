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
            print(realm.configuration.fileURL?.path ?? "PATH IS NIL")
            return realm
        }()
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter object: The type of object to retrieve.
    /// - Returns: The array in the database for the given object type.
    func fetch<T: Object>(object: T.Type) -> Array<T> {
        print("DATA FETCHED")
        let results = Array(realm.objects(T.self))
        return results
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
