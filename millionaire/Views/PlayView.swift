//
//  PlayView.swift
//  millionaire
//
//  Created by huynh on 13/5/25.
//

import Foundation
import SwiftUI

struct PlayView: View {

    // MARK: Properties
    @ObservedObject var gameManager: GameManager
    @GestureState private var dragOffset = CGSize.zero

    @State private var showInfoOverlay = false
    @State private var statusLocationX: CGFloat = UIScreen.main.bounds.width
    @State private var selectedLifeline: LifelineType? = nil

    private let statusLocationXWillAppear: CGFloat = screenWidth
    private let statusLocationXDidAppear: CGFloat = screenWidth*(0.2)

    // MARK: Body layer
    var body: some View {
        ZStack {
            // Main view
            VStack(spacing: 20) {
                // Show play info button
                ShowPlayInfoButton(
                    isShowing: showInfoOverlay,
                    action: showPlayInfoView
                ).frame(height: 50).padding()

                // Question view
                QuestionView(
                    remainingTime: gameManager.remainingTime,
                    index: gameManager.currentIndex,
                    text: gameManager.currentQuestion!.text
                ).padding(20)

                // Answer view
                answerButtons
                Spacer()

                // Lifelines View
                lifeLineButtons.padding()
                Spacer()
            }.padding().disabled(gameManager.state == .gameOver)

            // Information view
            GameStatusView(
                currentIndex: gameManager.currentIndex,
                locationX: $statusLocationX
            )
            .gesture(hiddenPlayInfoWithTouch())
            .gesture(hiddenPlayInfoWithSwipe())
            .opacity(showInfoOverlay ? 1 : 0)

            // Ask audience view
            if gameManager.state == .askTheAudience {
                AskAudienceView(
                    answerPercent: gameManager.answerPercentages,
                    okAction: gameManager.resumeGame
                )
            } else if gameManager.state == .phoneAFriend {
                PhoneAFriendView(
                    answerIndex: gameManager.currentQuestion!.correctIndex,
                    okAction: gameManager.resumeGame
                )
            }
        }
        .background(BackgroundImgView(img: .play))
        .animation(.easeOut(duration: 0.25), value: gameManager.state)
        .gesture(showPlayInfoWithSwipe())
        .onChange(of: gameManager.autoShowInfo) { _, new in
            new ? showPlayInfoView() : hiddenPlayInfoView()
        }
        .onChange(of: gameManager.state) { _, newState in
            if newState == .gameOver {
                showPlayInfoView()
            }
        }
    }

    // MARK: Views

    /// Answer view
    private var answerButtons: some View {
        ForEach(Array(gameManager.currentQuestion!.options.enumerated()), id: \.0) { index, text in
            let option = AnswerOption.allCases[index]
            AnswerButtonView(
                optionKey: option.label,
                optionText: text,
                isSelected: gameManager.selectedAnswer == option,
                isCorrect: gameManager.isAnswerCorrect,
                action: {gameManager.selectAnswer(option)}
            )
            .disabled(gameManager.selectedAnswer != nil || text == "")
        }
    }

    /// Lifelines View
    private var lifeLineButtons: some View {
        HStack(alignment: .center, spacing: 20) {
            LifelineButton(
                type: .fiftyFifty,
                disabled: gameManager.usedLifelines.contains(.fiftyFifty),
                action: {selectedLifeline = .fiftyFifty}
            )
            LifelineButton(
                type: .phoneAFriend,
                disabled: gameManager.usedLifelines.contains(.phoneAFriend),
                action: {selectedLifeline = .phoneAFriend}
            )
            LifelineButton(
                type: .askAudience,
                disabled: gameManager.usedLifelines.contains(.askAudience),
                action: {selectedLifeline = .askAudience}
            )
        }
        .frame(width: screenWidth, height: 50)
        .padding(.bottom, 20)
        .alert(item: $selectedLifeline) { lifeline in
            Alert(
                title: Text("Xác nhận"),
                message: Text("Bạn muốn dùng trợ giúp \(lifeline.label)?"),
                primaryButton: .default(Text("Dùng")) {
                    gameManager.useLifeline(lifeline)
                },
                secondaryButton: .cancel(Text("Không"))
            )
        }
    }

    // MARK: Private methods

    private func showPlayInfoView() {
        withAnimation() {
            statusLocationX = statusLocationXDidAppear
            showInfoOverlay = true
        }
    }

    private func hiddenPlayInfoView() {
        withAnimation() {
            statusLocationX = statusLocationXWillAppear
            showInfoOverlay = false
        }
    }

    private func showPlayInfoWithSwipe() -> some Gesture {
        DragGesture().updating($dragOffset) { value, _, _ in
            // Must swipe on the right edge of the screen
            let isRightEdge = UIScreen.main.bounds.width - value.startLocation.x < 50
            // Swipe must go to the left
            let isToLeft = value.translation.width < 0
            if isRightEdge && isToLeft {
                showPlayInfoView()
            }
        }
    }

    private func hiddenPlayInfoWithTouch() -> some Gesture {
        TapGesture().onEnded {
            hiddenPlayInfoView()
        }
    }

    private func hiddenPlayInfoWithSwipe() -> some Gesture {
        DragGesture().updating($dragOffset) { value, _, _ in
            // Swipe must go to the right
            let isToRight = value.translation.width > 0
            if isToRight {
                hiddenPlayInfoView()
            }
        }
    }
}

#Preview {
    PlayView(gameManager: GameManager())
}
