//
//  CountdownCircleView.swift
//  millionaire
//
//  Created by huynh on 16/5/25.
//

import SwiftUI

struct CountdownCircleView: View {
    var remainingTime: TimeInterval
    let totalTime: TimeInterval = 30

    var progress: CGFloat {
        CGFloat(remainingTime / totalTime)
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(.white)
                .stroke(.gray.opacity(0.8), style: StrokeStyle(lineWidth: 8, lineCap: .square))

            // Countdown (effectively cuts the application over time)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(timerColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .square))
                .rotationEffect(.degrees(-90))// Start from the beginning
                .animation(.linear(duration: 1), value: progress)

            // Time number(s) remaining
            Text("\(Int(remainingTime))")
                .foregroundStyle(.black)
                .font(.title)
                .bold()
        }
    }

    var timerColor: Color {
        switch remainingTime {
        case 0..<10:
            return .red
        case 5..<15:
            return .yellow
        default:
            return .green
        }
    }
}

#Preview {
    CountdownCircleView(remainingTime: 30)
}
