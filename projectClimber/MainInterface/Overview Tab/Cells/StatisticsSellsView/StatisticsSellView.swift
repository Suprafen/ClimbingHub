//
//  StatisticsSellView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 9.02.23.
//

import SwiftUI
@available (iOS 16, *)
struct StatisticsSellView: View {
    
    var statistics: Statistics
    
    var body: some View {
        VStack {
            switch statistics.type {
            case .graph:
                Text("Graph")
            case .hangBoard:
                VStack(alignment: .leading) {
                    WorkoutsDoneView()
                        .frame(maxHeight: 70)
                    
                    LongestHangView()
                        .frame(maxHeight: 70)
                }
                .foregroundColor(.white)
            case .totalTime:
                DailyGoalStatusView()
            }
        }
    }
}
