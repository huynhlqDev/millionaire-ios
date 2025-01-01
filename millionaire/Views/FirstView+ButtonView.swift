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
        NavigationView {
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
                        
                        NavigationLink(destination: GameplayView()) {
                            FirstViewButton(title: "High Score")
                        }
                        NavigationLink(destination: GameplayView()) {
                            FirstViewButton(title: "Rule")
                        }
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
        }
        .navigationBarTitle("Home", displayMode: .inline)

    }}

struct FirstViewButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: buttonWidth, height: 50)
            .background(Color.blue)
            .cornerRadius(10)
            .overlay( // Add border line
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 2)
    }
}


#Preview { FirstView()}

