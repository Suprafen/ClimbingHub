import SwiftUI

@available (iOS 16, *)
struct StatisticsCellView: View {
    
    var statistics: Statistics
    var foregroundColor: Color
    var body: some View {
        HStack {
            VStack {
                switch statistics.type {
                case .graph:
                    Text("Graph")
                case .hangBoard:
                    VStack(alignment: .leading) {
                        TimeSpentDuringWorkoutsView(foregroundColor: foregroundColor)
                            .frame(maxHeight: 70)
                        AmountOfDoneWorkoutsView()
                            .frame(maxHeight: 70)
                    }
                case .totalTime:
                    DailyGoalStatusView(foregroundColor: foregroundColor)
                }
            }
            Spacer()
        }
        .padding(20)
    }
}

@available (iOS 16, *)
struct StatisticsCell_Previes: PreviewProvider {
    static var previews: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.blue.opacity(0.3))
                .frame(maxHeight: 200)
                .padding(10)
            StatisticsCellView(statistics: Statistics(),
                               foregroundColor: .black)
                .background(.red.opacity(0.6))
        }
    }
}
