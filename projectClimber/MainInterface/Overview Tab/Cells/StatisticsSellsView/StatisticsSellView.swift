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
                HStack {
                    VStack {
                        Text("Here could be a description. Maybe even useful one")
                            .font(.body)
                            .italic()
                        Spacer()
                        Text("\(statistics.titleStatistics)")
                    }
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
            case .totalTime:
                HStack {
                    Text("\(statistics.titleStatistics)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
