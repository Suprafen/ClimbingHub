//
//  Extension.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 15.02.22.
//

import Foundation
import RealmSwift

extension String {
    static func makeTimeString(seconds: Int, withLetterDescription: Bool) -> String {
        
        let tuple = ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
        
        var timeString = ""
        if withLetterDescription {
            
            switch tuple {
            case (0, 0, 0...59):
                timeString += String(format: "%2d", tuple.2)
                timeString += "s"
                return timeString
            case (0 ,0...59 ,0...59):
                timeString += String(format: "%2d", tuple.1)
                timeString += "m "
                timeString += String(format: "%2d", tuple.2)
                timeString += "s"
                
                return timeString
            case (0...1000, 0...59, 0...59):
                timeString += String(format: "%2d", tuple.0)
                timeString += "h"
                timeString += String(format: "%2d", tuple.1)
                timeString += "m "
                timeString += String(format: "%2d", tuple.2)
                timeString += "s"
                return timeString
            default:
                return timeString
            }
        } else {
            
            
                timeString += String(format: "%02d", tuple.0)
                timeString += ":"
                timeString += String(format: "%02d", tuple.1)
                timeString += ":"
                timeString += String(format: "%02d", tuple.2)
                return timeString
            
        }
    }
}

extension Workout {
    /// Return a tuple of two Int values, which is total time and time on hang board respectievely.
    ///
    /// - Parameter objects: Array of workouts which will be iterated through
    /// - Returns: Int tuple (Int, Int) – (TotalTime, TimeOnHangBoard)
    static func combineWorkoutTime(in objects: [Object]) -> (Int,Int) {
        let workouts = objects as! [Workout]
        
        var tempTotalTime: Int = 0
        var tempTimeOnHangBoard: Int = 0
        
        for workout in workouts {
            if let timeOnHangBoard = workout.timeOnHangBoard {
                tempTimeOnHangBoard += timeOnHangBoard
            }
            tempTotalTime += workout.totalTime
        }
        
        return (tempTotalTime, tempTimeOnHangBoard)
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

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

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}
