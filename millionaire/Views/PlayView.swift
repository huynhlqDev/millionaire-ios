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
            Text("Câu hỏi số \(gameManager.currentIndex + 1)")
                .font(.headline)

            QuestionView(text: gameManager.currentQuestion.text)

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
            }

            Spacer()

            if gameManager.isGameOver == true {
                Text("Bạn đã trả lời sai!")
                    .foregroundColor(.red)
                    .bold()
                Button("Chơi lại") {
                    gameManager.currentIndex = 0
                    gameManager.selectedAnswer = nil
                    gameManager.isAnswerCorrect = nil
                    gameManager.isGameOver = false
                }
            }
        }
        .padding()
    }

}

#Preview {
    PlayView()
}
