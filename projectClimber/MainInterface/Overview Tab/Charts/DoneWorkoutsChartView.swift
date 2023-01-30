//
//  DoneWorkoutsChartView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 24.09.22.
//

import SwiftUI
import Charts

@available (iOS 16.0, *)
struct DoneWorkoutsChartView: View {
    var body: some View {
        Chart (sales) { pancake in
            BarMark(x: .value("Name", pancake.name),
                    yStart: .value("Sales", pancake.sold),
                    yEnd: .value("Sales", pancake.sold * 2),
                    width: .ratio(0.3)
            ).clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .chartXAxis(.hidden)
        .padding(20)
    }
}

struct Pancake: Identifiable {
    let name: String
    let sold: Int
    var id: String { name }
}

let sales: [Pancake] = [
    .init(name: "Cachapa", sold: 915),
    .init(name: "Jinga", sold: 845),
    .init(name: "Chibuba", sold: 476),
    .init(name: "Mumbaie", sold: 915),
    .init(name: "Figura", sold: 498),
    .init(name: "Zijopa", sold: 678),
    .init(name: "Moiyna", sold: 731),
]
