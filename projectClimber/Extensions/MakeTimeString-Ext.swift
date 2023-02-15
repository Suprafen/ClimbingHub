//
//  MakeTimeString-Ext.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation

extension String {
    static func makeTimeString(seconds: Int, withLetterDescription: Bool) -> String {
        
        let tuple = ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
        
        var timeString = ""
        if withLetterDescription {
            
            switch tuple {
            case (0, 0, 0...59):
                timeString += String(format: "%2d", tuple.2)
                timeString += "s"
                return timeString
            case (0 ,0...59 ,0...59):
                timeString += String(format: "%2d", tuple.1)
                timeString += "m "
                timeString += String(format: "%2d", tuple.2)
                timeString += "s"
                
                return timeString
            case (0...1000, 0...59, 0...59):
                timeString += String(format: "%2d", tuple.0)
                timeString += "h"
                timeString += String(format: "%2d", tuple.1)
                timeString += "m "
                timeString += String(format: "%2d", tuple.2)
                timeString += "s"
                return timeString
            default:
                return timeString
            }
        } else {
            
            
                timeString += String(format: "%02d", tuple.0)
                timeString += ":"
                timeString += String(format: "%02d", tuple.1)
                timeString += ":"
                timeString += String(format: "%02d", tuple.2)
                return timeString
            
        }
    }
}
