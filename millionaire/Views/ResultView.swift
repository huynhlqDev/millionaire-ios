//
//  WinView.swift
//  millionaire
//
//  Created by huynh on 13/5/25.
//

import Foundation
import SwiftUI

struct ResultView: View {
    var state: GameState
    var action: () -> Void
    
    var body: some View {
        switch state {
        case .gameOver:
            Text("you answer wrong!")
                .foregroundColor(.red)
                .bold()
            Button("Try again") {
                action()
            }
        default:
            Text("you are winner!")
                .foregroundColor(.green)
                .bold()
            Button("OK") {
                action()
            }
        }
    }
}

#Preview {
    ResultView(state: .gameOver, action: {})
}

