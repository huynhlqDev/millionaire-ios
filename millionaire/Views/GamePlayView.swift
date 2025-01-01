//
//  ContentView.swift
//  millionaire
//
//  Created by huynh on 18/12/24.
//
import SwiftUI
import SwiftUI

struct GameplayView: View {
    private let questions: [Question] = [
        Question(level: .easy, question: "Câu hỏi 1: Thủ đô của Việt Nam là gì?", answers: ["Hà Nội", "TP.HCM", "Đà Nẵng", "Hải Phòng"], correctAnswer: 0),
        Question(level: .medium, question: "Câu hỏi 2: Mặt trăng có mấy vòng quay?", answers: ["1", "2", "3", "4"], correctAnswer: 0),
        Question(level: .hard, question: "Câu hỏi 3: AI là gì?", answers: ["Artificial Intelligence", "Artificial Invention", "Artificial Integration", "Artificial Imagination"], correctAnswer: 0)
    ]

    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var isGameOver: Bool = false
    @State private var hasWon: Bool = false
    @State private var remainingTime: Int = 30
    @State private var score: Int = 0

    var body: some View {
        ZStack {
            // Background Image
            Image("bg-play")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea()

            VStack {
                // Header: Back Button, Logo, Scoreboard
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        Text("Back")
                            .fontWeight(.bold)
                            .padding()
                    }
                    Spacer()

                    // App logo
                    Image("logo-main")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: logoSize/2)

                    Spacer()

                    Text("12345") // Placeholder for actual scoreboard
                        .fontWeight(.bold)
                        .padding()
                }
                .padding(.top)

                // Question Information
                HStack {
                    Text("Câu hỏi \(currentQuestionIndex + 1)")
                        .font(.title2)
                    Spacer()
                    Text("Thời gian: \(remainingTime)s")
                        .font(.title2)
                }
                .padding()

                // Question Text
                Text(questions[currentQuestionIndex].question)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()

                // Answer Buttons
                VStack {
                    ForEach(
                        0..<questions[currentQuestionIndex].answers.count,
                        id: \.self
                    ) { index in
                        Button(action: {
                            selectedAnswerIndex = index
                            checkAnswer(selectedIndex: index)
                        }) {
                            Text(questions[currentQuestionIndex].answers[index])
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedAnswerIndex == index ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(5)
                    }
                }
                Spacer()

                // Support Buttons
                HStack {
                    Button(action: {
                        // Support 1 action
                    }) {
                        Text("Support 1")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        // Support 2 action
                    }) {
                        Text("Support 2")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        // Support 3 action
                    }) {
                        Text("Support 3")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)

                // Game Over or Win State
                if isGameOver {
                    Text(hasWon ? "Bạn thắng!" : "Game Over!")
                        .font(.title)
                        .foregroundColor(hasWon ? .green : .red)
                        .padding()
                } else {
                    Text("")
                }
                Spacer()

            }
            .padding()
            .onAppear {
                startTimer()
            }
        }
    }

    func checkAnswer(selectedIndex: Int) {
        let currentQuestion = questions[currentQuestionIndex]

        if selectedIndex == currentQuestion.correctAnswer {
            // Nếu trả lời đúng, chuyển sang câu hỏi tiếp theo
            if currentQuestionIndex + 1 < questions.count {
                currentQuestionIndex += 1
                selectedAnswerIndex = nil  // Reset lựa chọn
            } else {
                // Nếu hết câu hỏi, kết thúc game
                isGameOver = true
                hasWon = true
            }
        } else {
            // Nếu sai, kết thúc game
            isGameOver = true
            hasWon = false
        }
    }

    // Timer function
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer.invalidate()
                isGameOver = true
                hasWon = false
            }
        }
    }
}

#Preview {
    GameplayView()
}
