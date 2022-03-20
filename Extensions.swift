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
