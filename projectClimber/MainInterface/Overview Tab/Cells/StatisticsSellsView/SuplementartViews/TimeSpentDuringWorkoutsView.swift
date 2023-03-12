import Foundation
import SwiftUI
struct TimeSpentDuringWorkoutsView: View {
    var foregroundColor: Color
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("1000")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                    .foregroundColor(.blue.opacity(0.7))
                VStack {
                    Spacer()
                    // FIXME: Provide the real amount of minutes spent during all workouts
                    Text(/*amount > 60 ? */"min" /*: "sec"*/)
                        .foregroundColor(.blue.opacity(0.7))
                        .bold()
                }
            }
            Text("You’ve been working out")
                .font(.callout)
            Spacer(minLength: 20)
        }
        .foregroundColor(foregroundColor)
    }
}

struct WTimeSpentDuringWorkouts_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TimeSpentDuringWorkoutsView(foregroundColor: .black)
        }
        .frame(width: UIScreen.main.bounds.width,
               height: UIScreen.main.bounds.width / 2,
               alignment: .top)
        .background(.blue.opacity(0.3))
        .padding(20)
    }
}
