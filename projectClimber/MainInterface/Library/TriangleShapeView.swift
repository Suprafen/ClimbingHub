//
//  TriangleShapeView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 12.03.23.
//

import SwiftUI

struct TriangleShapeView: Shape {
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        path.closeSubpath()
        
        return path
    }
    
}

struct TriangleShapeView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleShapeView()
            .frame(width: 200, height: 350)
    }
}
