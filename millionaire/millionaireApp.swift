//
//  millionaireApp.swift
//  millionaire
//
//  Created by huynh on 18/12/24.
//

import SwiftUI
import SwiftData

@main
struct millionaireApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Player.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    @StateObject private var gameManager: GameManager = GameManager()

    var body: some Scene {
        WindowGroup {
            PlayView(gameManager: gameManager)
        }
//        .modelContainer(sharedModelContainer)
    }
}
