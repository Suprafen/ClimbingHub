//
//  Workout.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 21.01.22.
//

import Foundation
import RealmSwift

enum WorkoutType: String, PersistableEnum {
    case fingerWorkout = "Finger Workout"
}
// Type for statistics
enum StatisticsType: String, PersistableEnum {
    case hangBoard = "hangBoard"
    case totalTime = "totalTime"
    case graph = "graph"
}

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
// Just a container for statistics array
class StatContainer: Object {
     @Persisted var statistics = List<Statistics>()
}

class Statistics: Object {
    @Persisted var titleStatistics: String
    @Persisted var type: StatisticsType
    @Persisted var time: Int
    
    var workouts: [Workout]?
    
    convenience init(titleStatistics: String, time: Int, type: StatisticsType, workouts: [Workout]? = nil) {
        self.init()
        self.titleStatistics = titleStatistics
        self.time = time
        self.type = type
        self.workouts = workouts
    }
}
