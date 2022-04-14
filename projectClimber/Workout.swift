//
//  Workout.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 21.01.22.
//

import Foundation
import RealmSwift

enum WorkoutGoal: String, Codable, PersistableEnum {
    case openGoal = "Open Goal"
    case time = "Time"
    case custom = "Custom"
}

enum WorkoutType: String, Codable, PersistableEnum {
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
    @Persisted var goalType: WorkoutGoal
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

struct SectionForHistory: Hashable{
    var title: String
    var workouts: [Workout]
    
    var customHashValue: Int {
        var result: Int = 0
        for i in workouts {
            result += i.splits.reduce(0, +)
            
        }
        result += workouts.count
        return result
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func ==(lhs: SectionForHistory, rhs: SectionForHistory) -> Bool{
        return lhs.title == rhs.title || lhs.workouts.count == rhs.workouts.count || lhs.customHashValue == rhs.customHashValue
    }
}

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
