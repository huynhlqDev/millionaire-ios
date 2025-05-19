//
//  ShowPlayInfoButton.swift
//  millionaire
//
//  Created by HuynhLQ on 16/5/25.
//


import Foundation
import SwiftUI

struct ShowPlayInfoButton: View {
    var isShowing: Bool
    var action: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Button(action: action) {
                Image(systemName: "chevron.left").foregroundStyle(.white).bold()
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.5))
                    .clipShape(RoundedCorner(radius: 20,corners: .topLeft))
                    .clipShape(RoundedCorner(radius: 20,corners: .bottomLeft))
                    .offset(x: 10, y: 0)
                    .opacity(isShowing ? 0 : 1)
            }
        }
    }

    private struct RoundedCorner: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
}
