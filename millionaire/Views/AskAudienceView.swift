//
//  AskAudienceView.swift
//  millionaire
//
//  Created by HuynhLQ on 19/5/25.
//

import SwiftUI

struct AskAudienceView: View {
    let viewSize = UIScreen.main.bounds

    var answerPercent: [Int: Int]
    var okAction: () -> Void

    // Dashboard
    var body: some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay() {
                VStack {
                    Text("Ask Audience").font(.title).padding()
                    chartView
                    okButton
                }
                .frame(width: viewSize.width*0.8)
                .foregroundColor(Color.white)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(8)
                .shadow(radius: 12)
            }
        
    }
    
    // OK button
    var okButton: some View {
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
    
    //The chart shows the percentage of responses
    var chartView: some View {
        let columns = ["A", "B", "C", "D"]
        return (
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    // Need sort index to display in ABCD order
                    ForEach(answerPercent.sorted(by: {$0.key < $1.key}), id: \.0) { index, percent in
                        ColumnChartPercent(percent: percent)
                    }
                }
                .frame(width: viewSize.width*0.75,height: viewSize.height*0.2)
                .background(.gray.opacity(0.5))
                .cornerRadius(4)
                
                // White line
                Color.white
                    .frame(width: viewSize.width*0.75,height: 2)
                    .padding(.top, 2)
                
                HStack(spacing: 0) {
                    ForEach(columns, id: \.self) { column in
                        Text("\(column)").font(.title3).bold()
                            .padding(.top, 8)
                            .frame(width: viewSize.width*0.75/4, alignment: .center)
                    }
                }
            }
        )
    }
    
}

struct ColumnChartPercent: View {
    let percent: Int
    @State var label: String = "0%"
    @State var animatedPercent: CGFloat = 0
    
    let labelRatio = 0.2
    let columnRatio = 0.8
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                Text(label)
                    .frame(width: geometry.size.width/2, height: geometry.size.height*labelRatio)
                Color.green
                    .frame(width: geometry.size.width/2, height: geometry.size.height*columnRatio*animatedPercent)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("percent: \(percent)%")
                label = "\(percent)%"
                withAnimation(.interpolatingSpring(duration: 0.5)) {
                    animatedPercent = CGFloat(percent)/100
                    print("animatedPercent: \(animatedPercent)%")
                }
            }
            
        }
    }
}

#Preview {
    AskAudienceView(answerPercent: [1: 2, 3: 20, 0: 1, 2: 29], okAction: {})
    .background(BackgroundImgView(img: .play))
}
