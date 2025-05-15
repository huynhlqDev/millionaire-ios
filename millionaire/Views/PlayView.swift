//
//  PlayView.swift
//  millionaire
//
//  Created by huynh on 13/5/25.
//

import Foundation
import SwiftUI

struct PlayView: View {
    
    @StateObject var gameManager = GameManager()
    
    var body: some View {
        VStack(spacing: 20) {
            switch gameManager.gameState {
            case .gameOver:
                Text("you answer wrong!")
                    .foregroundColor(.red)
                    .bold()
                Button("Try again") {
                    gameManager.restartGame()
                }
            default:
                QuestionView(
                    number: gameManager.currentIndex + 1,
                    text: gameManager.currentQuestion.text
                )
                .padding(20)
                ForEach(Array(gameManager.currentQuestion.options.enumerated()), id: \.0) { index, text in
                    let option = AnswerOption.allCases[index]
                    AnswerButtonView(
                        optionKey: option.label,
                        optionText: text,
                        isSelected: gameManager.selectedAnswer == option,
                        isCorrect: gameManager.isAnswerCorrect,
                        action: {
                            gameManager.selectAnswer(option)
                        }
                    )
                    .disabled(gameManager.selectedAnswer != nil)
                }
//                Spacer()
            }
            
        }
        .background { BackgroundImgView(img: .play)}
        .onChange(of: gameManager.gameState) { oldValue, newValue in
            debugLog("game state changed from \(oldValue) to \(newValue)")
        }
        
    }
}

#Preview {
    PlayView()
}
