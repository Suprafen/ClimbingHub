import SwiftUI

struct AmountOfDoneWorkoutsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("543")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                    .foregroundColor(.orange.opacity(0.7))
            }
            Text("Workouts done so far")
                .font(.callout)
            Spacer(minLength: 20)
        }
    }
}

struct AmountOfDoneWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        AmountOfDoneWorkoutsView()
    }
}
