//
//  StatisticsType.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

enum StatisticsType: String, PersistableEnum {
    case hangBoard = "hangBoard"
    case totalTime = "totalTime"
    case graph = "graph"
}
