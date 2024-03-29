//
//  WelcomeViewReason.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 18.06.22.
//

import Foundation

struct WelcomeReason: Hashable {
    var id = UUID()
    var title: String
    var description: String
    var systemNameForImage: String
    
    init(title: String, description: String, systemNameForImage: String) {
        self.title = title
        self.description = description
        self.systemNameForImage = systemNameForImage
    }
    
    static func ==(lhs: WelcomeReason, rhs: WelcomeReason) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
    }
}
