//
//  GamePlayViewModel.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation
import SwiftUI

enum AnswerOption: String, CaseIterable, Identifiable {
    case A, B, C, D

    var id: String { rawValue}
    var label: String { rawValue }
    var index: Int? { Self.allCases.firstIndex(of: self)}
}

enum GameState {
    case welcome
    case playing
    case win
    case lose
    case result
}

class GameManager: ObservableObject {
    @Published var gameState: GameState = .welcome

    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var selectedAnswer: AnswerOption? = nil
    @Published var isAnswerCorrect: Bool? = nil
    @Published var isGameOver: Bool? = nil

    init() {
        self.questions = self.getQuestions()
    }

     func getQuestions() -> [Question] {
        [
            Question(
                text: "Thủ đô của Việt Nam là gì?",
                options: ["TP.HCM", "Đà Nẵng", "Hà Nội", "Huế"],
                correctIndex: 2
            ),
            Question(
                text: "Trái đất quay quanh gì?",
                options: ["Mặt trời", "Mặt trăng", "Sao Hoả", "Chính nó"],
                correctIndex: 0
            ),
            Question(
                text: "Ngôn ngữ chính của iOS là?",
                options: ["Java", "Swift", "Python", "C#"],
                correctIndex: 1
            ),
            Question(
                text: "Ai là tác giả của Truyện Kiều?",
                options: ["Nguyễn Du", "Nguyễn Trãi", "Hồ Xuân Hương", "Xuân Diệu"],
                correctIndex: 0
            )
        ]
    }


    var currentQuestion: Question {
        questions[currentIndex]
    }

    func startGame() {
        gameState = .playing
        currentIndex = 0
        selectedAnswer = nil
        isAnswerCorrect = nil
    }

    func selectAnswer(_ answer: AnswerOption) {
        selectedAnswer = answer

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            isAnswerCorrect = ( answer.index == currentQuestion.correctIndex)
            if isAnswerCorrect == true {
                goToNextQuestion()
            } else {
                gameState = .lose
                print("you lose")
            }
        }
    }

    func goToNextQuestion() {
        selectedAnswer = nil
        isAnswerCorrect = nil

        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            gameState = .win
            print("you win")
        }
    }

    func restartGame() {
        gameState = .welcome
    }
}
