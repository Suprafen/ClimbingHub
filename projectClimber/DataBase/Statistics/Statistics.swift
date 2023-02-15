//
//  Statistics.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

class Statistics: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
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
