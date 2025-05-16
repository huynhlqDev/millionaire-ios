//
//  PlayInfoView.swift
//  millionaire
//
//  Created by HuynhLQ on 16/5/25.
//

import SwiftUI

struct GameStatusView: View {
    var currentIndex: Int
    var locationX: CGFloat

    private let screenSize = UIScreen.main.bounds
    private let screenWidth = UIScreen.main.bounds.width*0.6

    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.5)
            // Content view
            HStack(spacing: 0) {
                // white line 1px
                Color.white.opacity(0.9)
                    .frame(width: 1, height: screenHeight)
                VStack {
                    Text("Price level")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding()

                    ForEach(1..<16) { index in
                        let indexReverse = 15 - index
                        PriceLevelView(
                            width: screenWidth,
                            index: indexReverse,
                            currentIndex: currentIndex,
                            isSelected: currentIndex == indexReverse+1
                        )
                    }
                    .font(.title)
                    .foregroundColor(Color.white)
                }
                .frame(width: screenWidth, height: screenSize.height)
                .allowsHitTesting(true)
                .background(.blue.opacity(0.6))
                .shadow(color: .black.opacity(0.8), radius: 4, x: 2, y: 2)
                .onTapGesture { return } // Keep action to hidden screen here
            }
            .offset(x: locationX, y: 0)
        }
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    GameStatusView(currentIndex: 10, locationX: UIScreen.main.bounds.width*(0.2))
}


