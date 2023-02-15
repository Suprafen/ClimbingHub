//
//  WorkoutsDoneView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import Foundation
import SwiftUI
struct WorkoutsDoneView: View {
    // TODO: Provide amount of workouts
    var body: some View {
        HStack {
            Text("\(12)")
                .font(.system(size: 80, design: .rounded))
                .bold()
            Spacer(minLength: 20)
            VStack {
                Spacer()
                Text("Workouts done")
                    .font(.title)
                    .bold()
            }
        }
    }
}
