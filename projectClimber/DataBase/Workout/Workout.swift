//
//  Workout.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 21.01.22.
//

import Foundation
import RealmSwift

class Workout: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var totalTime: Int
    @Persisted var date: Date
    @Persisted var splits: List<Int>
    @Persisted var type: WorkoutType
    @Persisted var goalType: WorkoutGoal
    @Persisted var userID: String
    //Computed time on hangboard according to splits
    var timeOnHangBoard: Int? {
        return splits.reduce(0) { totalValue, currentNum in
            totalValue + currentNum
        }
    }
    
    convenience init(totalTime: Int, date: Date, splits: List<Int>, workoutType: WorkoutType, goalType: WorkoutGoal, userID: String) {
        self.init()
        self.totalTime = totalTime
        self.date = date
        self.splits = splits
        self.type = workoutType
        self.goalType = goalType
        self.userID = userID
    }
}
