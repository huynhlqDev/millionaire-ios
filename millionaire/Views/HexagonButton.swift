//
//  OptionButton.swift
//  millionaire
//
//  Created by HuynhLQ on 15/5/25.
//

import SwiftUI

struct HexagonButton: Shape {
    
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        
        // Create points
        let points: [CGPoint] = [
            CGPoint(x: 0.075 * w, y: 0), // Top-left
            CGPoint(x: 0.925 * w, y: 0), // Top-right
            CGPoint(x: w, y: 0.5 * h), // Mid-right
            CGPoint(x: 0.925 * w, y: h), // Bottom-right
            CGPoint(x: 0.075 * w, y: h), // Bottom-left
            CGPoint(x: 0, y: 0.5 * h) // Mid-left
        ]
        
        var path = Path()
        path.move(to: points[0]) // Identify the first point to start the draw
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
    
    
}
