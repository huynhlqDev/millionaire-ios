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
    @GestureState private var dragOffset = CGSize.zero
    @StateObject var gameManager = GameManager()

    @State private var showInfoOverlay = false
    @State private var statusLocationX: CGFloat = UIScreen.main.bounds.width
    @State private var selectedLifeline: LifelineType? = nil

    private let statusLocationXWillAppear: CGFloat = UIScreen.main.bounds.width
    private let statusLocationXDidAppear: CGFloat = UIScreen.main.bounds.width*(0.2)

    // MARK: Body layer
    var body: some View {
        ZStack {
            // Play view
            VStack(spacing: 20) {
                // Show play info button
                HStack(spacing: 0) {
                    Spacer()
                    ShowPlayInfoButton(action: showPlayInfoView)
                        .opacity(showInfoOverlay ? 0 : 1)
                }.frame(height: 50)

                // Question view
                QuestionView(
                    number: gameManager.currentIndex + 1,
                    text: gameManager.currentQuestion!.text
                ).padding(20)

                // Answer view
                answerButtons
                if gameManager.gameState == .gameOver {
                    ResultView(state: .gameOver, action: gameManager.restartGame)
                }
                Spacer()

                // Lifelines View
                lifeLineButtons

            }
            .background(BackgroundImgView(img: .play))
            .overlay {
                // Information view
                GameStatusView(currentIndex: gameManager.currentIndex, locationX: $statusLocationX)
                    .gesture(hiddenPlayInfoWithTouch())
                    .gesture(hiddenPlayInfoWithSwipe())
                    .opacity(showInfoOverlay ? 1 : 0)
            }
        }
        .gesture(showPlayInfoWithSwipe())

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
                message: Text("Bạn muốn dùng trợ giúp '\(lifeline.rawValue)'?"),
                primaryButton: .default(Text("Dùng")) {
                    gameManager.useLifeline(lifeline)
                },
                secondaryButton: .cancel()
            )
        }
    }



    // MARK: Private methods

    /// Show Fifty-Fifty view handler
    private func handleFiftyFiftyTapped() {
        gameManager.applyFiftyFifty()
    }

    /// Show Phone A Friend view handler
    private func handlePhoneAFriendTapped() {
        
    }

    /// Show Ask Audience view handler
    private func handleAskAudienceTapped() {

    }

    private func showPlayInfoView() {
        withAnimation() {
            statusLocationX = statusLocationXDidAppear
            showInfoOverlay = true
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
            withAnimation() {
                statusLocationX = statusLocationXWillAppear
                showInfoOverlay = false
            }

        }
    }

    private func hiddenPlayInfoWithSwipe() -> some Gesture {
        DragGesture().updating($dragOffset) { value, _, _ in
            // Swipe must go to the right
            let isToRight = value.translation.width > 0
            if isToRight {
                withAnimation() {
                    statusLocationX = statusLocationXWillAppear
                    showInfoOverlay = false
                }
            }
        }
    }
}

#Preview {
    PlayView()
}
