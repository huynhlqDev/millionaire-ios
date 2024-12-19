//
//  ContentView.swift
//  millionaire
//
//  Created by huynh on 18/12/24.
//

import SwiftUI
import SwiftData

struct GamePlayView: View {
//    @Environment(\.modelContext) private var modelContext
    var questions: [Question]

    var body: some View {
        NavigationSplitView {

        } detail: {
            Text("Select an item")
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    GamePlayView(questions: [Question(level: .easy, question: "q1", answers: [], correctAnswer: 0)])
}
