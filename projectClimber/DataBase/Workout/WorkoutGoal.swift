//
//  WorkoutGoal.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

enum WorkoutGoal: String, Codable, PersistableEnum {
    case openGoal = "Open Goal"
    case time = "Time"
    case custom = "Custom"
}
