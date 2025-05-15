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
    case ready
    case playing
    case checkAnswer
    case showResult
    case support
    case gameOver
    case win
}

class GameManager: ObservableObject {
    @Published var gameState: GameState = .ready

    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var selectedAnswer: AnswerOption? = nil
    @Published var isAnswerCorrect: Bool? = nil
    @Published var isGameOver: Bool? = nil
    
    @Published var animateButton = false
    
    init() {
        startGame()
    }
    
    func getQuestions() -> [Question] {
        [
            
            Question(
                text: "What is the capital of France?",
                options: ["Berlin", "Madrid", "Paris", "Rome"],
                correctIndex: 2
            ),
            Question(
                text: "Which planet is known as the Red Planet?",
                options: ["Earth", "Mars", "Jupiter", "Saturn"],
                correctIndex: 1
            ),
            Question(
                text: "Who wrote 'To Kill a Mockingbird'?",
                options: ["Harper Lee", "Mark Twain", "Ernest Hemingway", "F. Scott Fitzgerald"],
                correctIndex: 0
            ),
            Question(
                text: "What is the largest ocean on Earth?",
                options: ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"],
                correctIndex: 3
            ),
            Question(
                text: "What is the smallest prime number?",
                options: ["1", "2", "3", "5"],
                correctIndex: 1
            )
            
        ]
    }
    
    
    var currentQuestion: Question {
        questions[currentIndex]
    }
    
    func startGame() {
        gameState = .playing
        questions = getQuestions()
    }
    
    func selectAnswer(_ answer: AnswerOption) {
        selectedAnswer = answer
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            isAnswerCorrect = ( answer.index == currentQuestion.correctIndex)
            if isAnswerCorrect == true {
                sleep(2) // Sleep 2s for success animation perform before go to next question.
                goToNextQuestion()
            } else {
                isGameOver = true
                gameState = .gameOver
            }
        }
    }
    
    func goToNextQuestion() {
        selectedAnswer = nil
        isAnswerCorrect = nil
        
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            isGameOver = true
            gameState = .win
            print("you win")
        }
    }
    
    func restartGame() {
        currentIndex = 0
        selectedAnswer = nil
        isAnswerCorrect = nil
        isGameOver = false
        gameState = .ready
    }
}
