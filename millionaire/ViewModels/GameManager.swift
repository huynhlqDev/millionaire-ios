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

enum GameState: Equatable {
    case playing
    case win
    case gameOver
    case fiftyFifty
    case askTheAudience
    case phoneAFriend
}

class GameManager: ObservableObject {
    @Published var state: GameState {
        didSet {
            debugLog("state changed to: \(state)")
        }
    }

    @Published var autoShowInfo: Bool = false

    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var selectedAnswer: AnswerOption? = nil
    @Published var isAnswerCorrect: Bool? = nil
    @Published var isGameOver: Bool? = nil

    @Published var usedLifelines: Set<LifelineType> = []
    @Published var answerPercentages: [Int : Int] = [:]
    var currentQuestion: Question?

    init() {
        state = .playing
        startGame()
    }

    private func getQuestions() -> [Question] {
        [
            Question(
                text: "What is the capital of France?",
                options: ["Berlin", "Madrid", "Paris", "Rome"],
                correctIndex: 2
            ),
            Question(
                text: "What is the capital of France?",
                options: ["Berlin", "Madrid", "Paris", "Rome"],
                correctIndex: 2
            ),
            Question(
                text: "What is the capital of France?",
                options: ["Berlin", "Madrid", "Paris", "Rome"],
                correctIndex: 2
            ),
            Question(
                text: "What is the capital of France?",
                options: ["Berlin", "Madrid", "Paris", "Rome"],
                correctIndex: 2
            ),
            Question(
                text: "What is the capital of France - end?",
                options: ["Berlin", "Madrid", "Paris", "Rome"],
                correctIndex: 2
            ),
            Question(
                text: "Which planet is known as the Red Planet?",
                options: ["Earth", "Mars", "Jupiter", "Saturn"],
                correctIndex: 1
            ),
            Question(
                text: "Which planet is known as the Red Planet?",
                options: ["Earth", "Mars", "Jupiter", "Saturn"],
                correctIndex: 1
            ),
            Question(
                text: "Which planet is known as the Red Planet?",
                options: ["Earth", "Mars", "Jupiter", "Saturn"],
                correctIndex: 1
            ),
            Question(
                text: "Which planet is known as the Red Planet?",
                options: ["Earth", "Mars", "Jupiter", "Saturn"],
                correctIndex: 1
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
                text: "Who wrote 'To Kill a Mockingbird'?",
                options: ["Harper Lee", "Mark Twain", "Ernest Hemingway", "F. Scott Fitzgerald"],
                correctIndex: 0
            ),
            Question(
                text: "Who wrote 'To Kill a Mockingbird'?",
                options: ["Harper Lee", "Mark Twain", "Ernest Hemingway", "F. Scott Fitzgerald"],
                correctIndex: 0
            ),
            Question(
                text: "Who wrote 'To Kill a Mockingbird'?",
                options: ["Harper Lee", "Mark Twain", "Ernest Hemingway", "F. Scott Fitzgerald"],
                correctIndex: 0
            ),
            Question(
                text: "Who wrote 'To Kill a Mockingbird'?",
                options: ["Harper Lee", "Mark Twain", "Ernest Hemingway", "F. Scott Fitzgerald"],
                correctIndex: 0
            ),
        ]
    }

    func startGame() {
        questions = getQuestions()
        currentQuestion = questions[currentIndex]
        SoundManager.shared.startPlayingMusic(with: currentIndex)
    }

    func resumeGame() {
        state = .playing
    }

    func selectAnswer(_ answer: AnswerOption) {
        selectedAnswer = answer

        // Sleep 2s for success animation perform before go to next question.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            isAnswerCorrect = ( answer.index == currentQuestion!.correctIndex)
            if isAnswerCorrect == true {
                if currentIndex == 14 { // Winner
                    SoundManager.shared.nextEffectLevelUp() {
                        self.goToNextQuestion()
                    }
                } else if currentIndex == 4 || currentIndex == 9 {
                    SoundManager.shared.nextEffectLevelUp() {
                        debugLog("Level Up complete")
                        SoundManager.shared.startPlayingMusic(with: self.currentIndex)
                        self.goToNextQuestion()
                        self.triggerAutoShowInfo()
                    }
                } else if currentIndex < 4 {
                    SoundManager.shared.playSound(.correct_short, isEffect: true)
                    self.goToNextQuestion()
                } else {
                    SoundManager.shared.playSound(.correct_long, isEffect: true) {
                        self.goToNextQuestion()
                    }
                }
            } else {
                SoundManager.shared.playSound(.gameOver) {
                    // Show alert thanks for your attendent
                }
                isGameOver = true
                state = .gameOver
            }
        }
    }

    func useLifeline(_ lifeline: LifelineType) {
        debugLog("lifeline used: \(lifeline)")
        guard !usedLifelines.contains(lifeline) else { return }

        usedLifelines.insert(lifeline)
        switch lifeline {
        case .fiftyFifty:
            applyFiftyFifty()
        case .askAudience:
            state = .askTheAudience
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self else { return }
                self.askTheAudience()
            }
        case .phoneAFriend:
            state = .phoneAFriend
            callAFriend()
        }
    }

    // MARK: PRIVATE METHOD

    private func applyFiftyFifty() {
        usedLifelines.insert(.fiftyFifty)
        guard let currentQuestion else { return }
        var newOptions = currentQuestion.options

        let incorrectIndices = [0,1,2,3].filter { $0 != currentQuestion.correctIndex }.shuffled().prefix(2)
        for index in incorrectIndices {
            newOptions[index] = ""
        }
        self.currentQuestion = Question(text: currentQuestion.text,
                                        options: newOptions,
                                        correctIndex: currentQuestion.correctIndex)
        SoundManager.shared.playSound(.result, isEffect: true)
    }

    private func askTheAudience() {
        usedLifelines.insert(.askAudience)
        let correctIndex = currentQuestion!.correctIndex
        if usedLifelines.contains(.fiftyFifty) {
            let remainingIndices = currentQuestion!.options.enumerated().filter {
                !$0.element.isEmpty
            }.map { $0.offset }
            debugLog("optionsIndex: \(remainingIndices)")
            answerPercentages = generateAnswerPercentages(correctIndex, remainingIndices: remainingIndices)
            debugLog("answerPercentages: \(String(describing: answerPercentages))")
        } else {
            answerPercentages = generateAnswerPercentages(correctIndex)
        }
        SoundManager.shared.playSound(.result, isEffect: true)
    }

    private func callAFriend() {
        usedLifelines.insert(.phoneAFriend)
    }

    // MARK: PRIVATE METHOD

    /// Generate percentage votes for each answer (used for Ask the Audience lifeline)
    /// - Parameters:
    ///   - correctIndex: The index of the correct answer
    ///   - remainingIndices: Optional – if 50/50 is used, pass in remaining indices (2 items)
    /// - Returns: Dictionary with answer index as key, and percentage as value
    private func generateAnswerPercentages(_ correctIndex: Int, remainingIndices: [Int]? = nil) -> [Int: Int] {
        var percentages: [Int: Int] = [:]
        let correctWeight = Int.random(in: 40...70)

        if let remaining = remainingIndices, remaining.count == 2 {
            // 🎯 Trường hợp 50/50
            let wrongWeight = 100 - correctWeight
            let wrongIndex = remaining.filter { $0 != correctIndex }.first

            for index in 0..<4 {
                if index == correctIndex {
                    percentages[index] = correctWeight
                } else if (index == wrongIndex) {
                    percentages[index] = wrongWeight
                } else {
                    percentages[index] = 0
                }
            }
        } else {
            var remaining = 100 - correctWeight
            var otherIndices = [0, 1, 2, 3].filter { $0 != correctIndex }
            otherIndices.shuffle()

            for i in 0..<otherIndices.count {
                let index = otherIndices[i]

                // Phân chia đều random phần còn lại
                let value = (i == otherIndices.count - 1)
                ? remaining
                : Int.random(in: 0...(remaining / (otherIndices.count - i)))

                percentages[index] = value
                remaining -= value
            }

            percentages[correctIndex] = correctWeight
        }

        return percentages
    }

    private func goToNextQuestion() {
        selectedAnswer = nil
        isAnswerCorrect = nil

        if currentIndex + 1 < questions.count {
            currentIndex += 1
            currentQuestion = questions[currentIndex]
        } else {
            SoundManager.shared.playSound(.lastGame) {
                // Show alert thanks for your attendent
            }
            isGameOver = true
            state = .win
        }
    }

    private func restartGame() {
        currentIndex = 0
        selectedAnswer = nil
        isAnswerCorrect = nil
        isGameOver = false
        currentQuestion = questions[currentIndex]
        usedLifelines.removeAll()
        state = .playing
    }

    private func triggerAutoShowInfo() {
        autoShowInfo = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.autoShowInfo = false
        }
    }

}

extension GameManager {
    
}
