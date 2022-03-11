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
            timeString += String(format: "%02d", tuple.0)
            timeString += "h "
            timeString += String(format: "%02d", tuple.1)
            timeString += "m "
            timeString += String(format: "%02d", tuple.2)
            timeString += "s"
            
            return timeString
        } else {
            timeString += String(format: "%02d", tuple.0)
            timeString += " : "
            timeString += String(format: "%02d", tuple.1)
            timeString += " : "
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
