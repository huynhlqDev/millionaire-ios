//
//  OKButtonView.swift
//  millionaire
//
//  Created by huynh on 24/5/25.
//

import SwiftUI

struct OKButtonView: View {
    var okAction: () -> Void = {}
    
    var body: some View {
        Button(action: okAction) {
            Text("OK")
                .foregroundStyle(.white).bold()
                .frame(width: 60, height: 30)
                .background(.white.opacity(0.5))
                .cornerRadius(8)
                .shadow(radius: 12)
                .padding()
        }
    }
}

#Preview {
    OKButtonView()
}
