//
//  BackgroundView.swift
//  millionaire
//
//  Created by HuynhLQ on 15/5/25.
//

import SwiftUI

enum BackgroundImg: String {
    case play = "bg-play"
    case main = "bg-main"
}

struct BackgroundImgView: View {
    var img: BackgroundImg
    
    var body: some View {
        ZStack {
            Image(img.rawValue)
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.size.width,
                    height: UIScreen.main.bounds.size.height
                )
                .clipped()
                .ignoresSafeArea()
            Color.black.edgesIgnoringSafeArea(.all).opacity(0.15)
        }
    }
}
