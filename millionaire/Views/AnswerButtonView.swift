//
//  AnswerButtonView.swift
//  millionaire
//
//  Created by huynh on 13/5/25.
//

import Foundation
import SwiftUI

struct AnswerButtonView: View {
    @State private var animateButton = false
    
    let optionKey: String
    let optionText: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let buttonFrame: CGRect = CGRect(x: 0, y: 0, width: 0.8 * screenWidth, height: 50)
        
        HStack(spacing: 0) {
            Rectangle()
                .fill(.white)
                .frame(width: screenWidth * 0.1, height: 2)
            Button(action: action) {
                HexagonButton()
                    .fill(backgroundColor)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: buttonFrame.width, height: buttonFrame.height)
                    .overlay {
                        HStack {
                            Text("\(optionKey).").bold()
                                .padding(.leading)
                            Text(optionText)
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    .shadow(color: .black.opacity(0.7), radius: 4, x: 2, y: 2)
            }
            .frame(width: buttonFrame.width, height: buttonFrame.height)
            Rectangle()
                .fill(.white)
                .frame(width: screenWidth * 0.1, height: 2)
        }

    }
    
    private var backgroundColor: Color {
        let normalColor: Color = .blue.opacity(0.8)
        let selectedColor: Color = .yellow.opacity(0.8)
        let correctColor: Color = .green
        let incorrectColor: Color = .red
        
        // When answer unselected
        guard let isCorrect else {
            return isSelected ? selectedColor : normalColor
        }
        
        // When answer has been selected
        if isSelected && isCorrect {
            // If isCorrect perform success animation
            return animateButton ? correctColor : normalColor
        } else if isSelected && !isCorrect {
            return incorrectColor
        } else {
            return normalColor
        }
        
    }
}

#Preview {
    @Previewable @State var isSelected = false
    @Previewable @State var isCorrect: Bool? = nil
    AnswerButtonView(
        optionKey: "A",
        optionText: "option 1",
        isSelected: isSelected,
        isCorrect: isCorrect,
        action: {
            isSelected = true
            sleep(1)
            isCorrect = true
        }
    )
    .disabled(isSelected)
    .background {
        BackgroundImgView(img: .play)
    }
}
