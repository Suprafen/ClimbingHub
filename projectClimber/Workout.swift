//
//  Workout.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 21.01.22.
//

import Foundation
import RealmSwift


protocol WorkoutInfoProtocol{
    var totalTime: Int {get set}
    var date: Date {get set}
}

class Workout: Object {
    @Persisted var totalTime: Int
    @Persisted var date: Date
    @Persisted var splits: List<Int>
    @Persisted var type: WorkoutType
    //Computed time on handboard according to splits
    var timeOnHangBoard: Int? {
        return splits.reduce(0) { totalValue, currentNum in
            totalValue + currentNum
        }
    }
}

enum WorkoutType: String, PersistableEnum {
    case fingerWorkout = "Finger Workout"
}

class Statistics: Object {
    @Persisted var totalTimeOnHangboard: Int
    @Persisted var totalWorkoutTime: Int
    
    func combineWorkoutTime(in objects: [Object]) {
        totalTimeOnHangboard = 0
        totalWorkoutTime = 0
        let workouts = objects as! [Workout]
        for workout in workouts {
            if let timeOnHangboard = workout.timeOnHangBoard {
                self.totalTimeOnHangboard += timeOnHangboard
            }
            self.totalWorkoutTime += workout.totalTime
        }
    }
}
