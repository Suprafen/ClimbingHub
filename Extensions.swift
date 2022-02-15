//
//  Extension.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 15.02.22.
//

import Foundation

extension String {
    static func makeTimeString(seconds: Int) -> String {
        
        let tuple = ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
        
        var timeString = ""
        
        timeString += String(format: "%02d", tuple.0)
        timeString += " : "
        timeString += String(format: "%02d", tuple.1)
        timeString += " : "
        timeString += String(format: "%02d", tuple.2)
        
        return timeString
    }
}
