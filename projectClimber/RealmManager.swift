//
//  RealmController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 6.02.22.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private let realm: Realm
    
    static let sharedInstance = RealmManager()
    private init() {
        do {
            realm = try! Realm()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // Retrieves the given object type from the database.
    //
    // Parameter object: The type of object to retrieve.
    // Returns: The results in the database for the given object type.
    func fetch<T: Object>(object: T) -> Results<T> {
        return realm.objects(T.self)
    }
    
    func saveData() {
        
    }
}

//RealmManager.realm.getData()
