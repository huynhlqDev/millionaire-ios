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
    private let statusLocationXWillAppear: CGFloat = UIScreen.main.bounds.width
    private let statusLocationXDidAppear: CGFloat = UIScreen.main.bounds.width*(0.2)

    // MARK: Body
    var body: some View {
        ZStack {
            // Play view
            VStack(spacing: 20) {
                // Show play info button
                HStack(spacing: 0) {
                    if !showInfoOverlay {
                        Spacer()
                        ShowPlayInfoButton(action: showPlayInfoView)
                    }
                }
                .frame(height: 50)
                
                // Question view
                QuestionView(
                    number: gameManager.currentIndex + 1,
                    text: gameManager.currentQuestion.text
                )
                .padding(20)
                
                // Answer view
                ForEach(Array(gameManager.currentQuestion.options.enumerated()), id: \.0) { index, text in
                    let option = AnswerOption.allCases[index]
                    AnswerButtonView(
                        optionKey: option.label,
                        optionText: text,
                        isSelected: gameManager.selectedAnswer == option,
                        isCorrect: gameManager.isAnswerCorrect,
                        action: {gameManager.selectAnswer(option)}
                    )
                    .disabled(gameManager.selectedAnswer != nil)
                }
                if gameManager.gameState == .gameOver {
                    ResultView(state: .gameOver, action: gameManager.restartGame)
                }
                Spacer()
            }
            .background(BackgroundImgView(img: .play))
            .onChange(of: gameManager.gameState) { oldValue, newValue in
                debugLog("game state changed from \(oldValue) to \(newValue)")
            }
            
            // Information view
            .overlay {
                GameStatusView(currentIndex: gameManager.currentIndex, locationX: $statusLocationX)
                    .gesture(hiddenPlayInfoWithTouch())
                    .gesture(hiddenPlayInfoWithSwipe())
                    .opacity(showInfoOverlay ? 1 : 0)
            }
            
        }
        .gesture(showPlayInfoWithSwipe())
        
    }
    
    // MARK: Animation methods
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
