//
//  LongestHangView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.02.23.
//

import SwiftUI

struct LongestHangView: View {
    // TODO: provide seconds
    var body: some View {
        HStack {
            HStack {
                Text("\(125/60)")
                    .font(.system(size: 80, design: .rounded))
                    .bold()
                VStack {
                    Spacer()
                    Text("min")
                }
            }
            Spacer(minLength: 20)
            VStack {
                Spacer()
                Text("Longest hang")
                    .font(.title)
                    .bold()
            }
        }
    }
}
