//
//  Player.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation
import SwiftData

@Model
class Player {
    @Attribute(.unique) var id: UUID
    var name: String
    var score: Int

    init(id: UUID = UUID(), name: String, score: Int = 0) {
        self.id = id
        self.name = name
        self.score = score
    }
}

