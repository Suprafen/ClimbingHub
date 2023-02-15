//
//  HistorySection.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation

struct HistorySection {
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
}

extension HistorySection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func ==(lhs: HistorySection, rhs: HistorySection) -> Bool{
        return lhs.title == rhs.title || lhs.workouts.count == rhs.workouts.count || lhs.customHashValue == rhs.customHashValue
    }
}
