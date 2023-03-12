import SwiftUI

struct DailyGoalStatusView: View {
    @State private var isGoalDone: Bool = false
    @State private var progress: Double = 0.6
    var foregroundColor: Color
    var body: some View {
        HStack(spacing: 20) {
            TriangleProgressView(progress: $progress, strokeWidth: 15, strokeColor: .blue.opacity(0.7))
                .contentShape(Rectangle())
                .onTapGesture {
                    if progress < 1.0 {
                        withAnimation {
                            progress += 0.2
                        }
                    }
                }

            VStack (alignment: .leading) {
                
                Text("0/130min")
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .foregroundColor(.blue.opacity(0.7))
                
                Text("Workout time")
            }
        }
        .foregroundColor(foregroundColor)
    }
}
