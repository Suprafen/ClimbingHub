//
//  WorkoutType.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

enum WorkoutType: String, Codable, PersistableEnum {
    case fingerWorkout = "Finger Workout"
}
