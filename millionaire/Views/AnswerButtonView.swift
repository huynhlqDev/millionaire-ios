//
//  AnswerButtonView.swift
//  millionaire
//
//  Created by huynh on 13/5/25.
//

import Foundation
import SwiftUI

struct AnswerButtonView: View {
    let optionKey: String
    let optionText: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(optionKey).bold()
                Text(optionText)
                Spacer()
            }
        }
        .padding()
        .foregroundColor(.white)
        .cornerRadius(10)
        .background(backgroundColor)
    }

    private var backgroundColor: Color {
        if let isCorrect = isCorrect {
            if isSelected {
                return isCorrect ? .green : .red
            } else {
                return Color.yellow.opacity(0.5)
            }
        } else {
            return isSelected ? .blue : .blue.opacity(0.8)
        }
    }
}

#Preview {
    @Previewable @State var isSelected = false
    @Previewable @State var isCorrect: Bool? = nil
    AnswerButtonView(
        optionKey: "A",
        optionText: "Đáp án 1",
        isSelected: isSelected,
        isCorrect: isCorrect,
        action: {
            isSelected.toggle()
            sleep(2)
            isCorrect = false
        }
    )
}
