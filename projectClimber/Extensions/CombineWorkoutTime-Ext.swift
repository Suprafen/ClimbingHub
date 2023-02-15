//
//  CombineWorkoutTime-Ext.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

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
