//
//  QuestionView.swift
//  millionaire
//
//  Created by huynh on 13/5/25.
//

import Foundation
import SwiftUI

struct QuestionView: View {
    var remainingTime: Int = 30
    var number: Int
    var text: String
    private let viewWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    private let viewHeight: CGFloat = UIScreen.main.bounds.height * 0.2
    private let circleSize: CGFloat = 68

    var body: some View {
        VStack {
            Text("Question \(number)")
                .font(.headline)
                .frame(width: viewWidth, height: 36)
            Text(text)
            Spacer()
        }
        .padding(.top, circleSize/2)
        .frame(width: viewWidth, height: viewHeight)
        .foregroundStyle(.white)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.opacity(0.9))
                .stroke(.white, lineWidth: 2)
                .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
        }
        .overlay {
            CountdownCircleView(circleSize: circleSize)
            .offset(x: 0, y: -viewHeight/2)

        }
    }
}
