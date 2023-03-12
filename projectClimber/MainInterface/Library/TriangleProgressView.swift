
import SwiftUI

fileprivate struct TriangleProgressViewStyle: ProgressViewStyle {
    
    var strokeColor = Color.white
    var strokeWidth = 10.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionalCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack {
            TriangleShapeView()
                .trim(from: 0, to: fractionalCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
        }
    }
}

struct TriangleProgressView: View {
    
    @Binding var progress: Double
    let strokeWidth: Double
    let strokeColor: Color
    @State private var localProgress = 0.0
    var body: some View {
        ZStack {
            TriangleShapeView()
                .stroke(strokeColor.opacity(0.3), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .butt, lineJoin: .round))
                .frame(width: 100, height: 100)
            
            ProgressView(value: localProgress, total: 1.0)
                .progressViewStyle(TriangleProgressViewStyle(strokeColor: strokeColor, strokeWidth: strokeWidth))
                .frame(width: 100, height: 100)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(1)) {
                localProgress = progress
            }
        }
    }
}
