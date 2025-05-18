//
//  LifelineButton.swift
//  millionaire
//
//  Created by huynh on 17/5/25.
//

import SwiftUI

enum LifelineType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }

    case fiftyFifty
    case askAudience
    case phoneAFriend

    var iconName: String {
        switch self {
        case .fiftyFifty:
            return "fifty_fifty"
        case .askAudience:
            return "ask_audience"
        case .phoneAFriend:
            return "phone_friend"
        }
    }
}

struct LifelineButton: View {
    let type: LifelineType
    let disabled: Bool
    let action: () -> Void

    var iconName: String {
        switch type {
        case .fiftyFifty:
            return "fifty_fifty"
        case .askAudience:
            return "ask_audience"
        case .phoneAFriend:
            return "phone_friend"
        }
    }

    var body: some View {
        Button(action: action) {
            ZStack() {
                Image(type.iconName)
                    .resizable()
                    .scaledToFit()
                if disabled {
                    Image("cannot")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .disabled(disabled)
    }
}

#Preview {
    HStack(alignment: .center) {
        LifelineButton(type: .fiftyFifty, disabled: false) {
            return
        }
        LifelineButton(type: .phoneAFriend, disabled: true) {
            return
        }
        LifelineButton(type: .askAudience, disabled: true) {
            return
        }
    }
}
