//
//  StatContainer.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import RealmSwift

/// A container for statistics array
class StatContainer: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
     @Persisted var statistics = List<Statistics>()
}
