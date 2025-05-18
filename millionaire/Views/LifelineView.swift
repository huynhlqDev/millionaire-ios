//
//  LifelineView.swift
//  millionaire
//
//  Created by huynh on 17/5/25.
//

import SwiftUI

struct LifelineView: View {
    @Binding var type: LifelineType
    let action: () -> Void

    var body: some View {
        switch type {
        case .fiftyFifty:
            Button("Fifty-fifty", action: action)
        case .phoneAFriend:
            Button("Phone a friend", action: action)
        case .askAudience:
            Button("Ask audience", action: action)
        }
    }
}
