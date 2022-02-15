//
//  Workout.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 21.01.22.
//

import Foundation
import RealmSwift


class FingerWorkout: Object {
    @Persisted var totalTime: Int
    @Persisted var date: Date
    @Persisted var splits: List<Int>
    //Computed time on handboard according to splits
    var timeOnHandBoard: Int {
        return splits.reduce(0) { totalValue, currentNum in
            totalValue + currentNum
        }
    }
}
