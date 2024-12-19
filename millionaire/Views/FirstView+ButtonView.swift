//
//  FirstView.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//
import SwiftUI
import SwiftData

struct FirstView: View {
    @State private var isMuted = true

    var body: some View {
        ZStack {
            // Background Image
            Image("bg-main")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // App logo
                Image("logo-main")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: logoSize)

                Spacer()

                // Game menu
                VStack(spacing: 20) {
                    FirstViewButton(title: "Play", action: {
                        print("Play tapped")
                    })

                    FirstViewButton(title: "High Score", action: {
                        print("High Score tapped")
                    })

                    FirstViewButton(title: "Rule", action: {
                        print("Rule tapped")
                    })
                }
                .padding(.top, 20)

                Spacer()

                // Mute button
                HStack {
                    Button(action: {
                        isMuted.toggle()
                        print(isMuted ? "Muted" : "Unmuted")
                    }) {
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                            .overlay( // Add border line
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                }
                .padding()
            }
        }
    }}

#Preview {
    FirstView()
}

struct FirstViewButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: buttonWidth, height: 50)
                .background(Color.blue)
                .cornerRadius(8)
                .overlay( // Add border line
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
        }
    }
}
