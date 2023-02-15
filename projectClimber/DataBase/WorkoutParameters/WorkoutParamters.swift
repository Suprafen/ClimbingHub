//
//  WorkoutParamters.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation

struct WorkoutParamters: Codable {
    var workoutGoal: WorkoutGoal = .openGoal
    var workoutType: WorkoutType = .fingerWorkout
    var numberOfSplits: Int = 10
    
    var numberOfRests: Int { get { numberOfSplits - 1 } }
    
    var durationOfEachSplit: Int = 30
    var durationOfEachRest: Int = 10
    var durationForTimeGoal: Int = 600
    
    var durationOfWorkout: Int {
        get { (durationOfEachRest * numberOfRests)
            + (durationOfEachSplit * numberOfSplits)}
    }
}
