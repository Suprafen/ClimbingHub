//
//  DailyGoalStatusView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import SwiftUI

struct DailyGoalStatusView: View {
    @State var isGoalDone: Bool = false
    var body: some View {
        
        GeometryReader { proxy in
            HStack(alignment: .center) {
                // FIXME: Wrong rectangle positioning.
                GeometryReader { proxy in
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(maxWidth: proxy.size.width / 1.5,
                               maxHeight: proxy.size.width / 1.5)
                }
                .background(Color.red)
                
                Text(isGoalDone ? "You've met your daily goal!" : "You need to train MIN_MIN more to acomplish")
                    .foregroundColor(.white)
                    .bold()
            }
        }
    }
}
