//
//  PriceLevelView.swift
//  millionaire
//
//  Created by huynh on 17/5/25.
//

import SwiftUI

struct PriceLevelView: View {
    var width: CGFloat
    var index: Int
    var currentIndex: Int
    var isSelected: Bool

    private var backgroundColor: Color {
        .yellow.opacity(isSelected ? 0.7 : 0)
    }

    private var textColor: Color {
        switch index+1 {
        case 5,10,15:
            return isSelected ? .black : .white
        default:
            return isSelected ? .black : .yellow
        }
    }

    private var label: String {
        switch index + 1 {
        case 1..<4:
            return "$\((index + 1)*200)"
        case 4:
            return "$\(1).000"
        case 5:
            return "$\(2).000"
        case 6:
            return "$\(3).000"
        case 7:
            return "$\(6).000"
        case 8:
            return "$\(10).000"
        case 9:
            return "$\(60).000"
        case 10:
            return "$\(22).000"
        case 11:
            return "$\(30).000"
        case 12:
            return "$\(40).000"
        case 13:
            return "$\(60).000"
        case 14:
            return "$\(85).000"
        case 15:
            return "$\(150).000"
        default:
            return "$0"
        }
    }

    var body: some View {
        let questionNumber = index + 1
        HexagonButton()
            .fill(backgroundColor)
            .stroke( isSelected ? .white : .clear, lineWidth: 2)
            .frame(width: width - 12, height: 30)
            .overlay {
                HStack {
                    // Question number
                    Text("\(questionNumber)")
                        .font(.system(size: 24))
                        .frame(width: 28, height: 30)
                    // Level start
                    VStack {
                        if index < currentIndex {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(textColor)
                        }
                    }
                    .frame(width: 28, height: 30)

                    // Price
                    switch questionNumber {
                    case 5,10,15:
                        Text(label).font(.system(size: 24)).bold()
                    default:
                        Text(label).font(.system(size: 24))
                    }
                }
                .foregroundStyle(textColor)
                .padding(.leading, 20)
                .frame(width: width, height: 30, alignment: .leading)
                .animation(.linear(duration: 0.15), value: isSelected)
            }
    }

}

#Preview {
    PriceLevelView(width: UIScreen.main.bounds.width*0.6,
                   index: 10,
                   currentIndex: 12,
                   isSelected: true)
}
