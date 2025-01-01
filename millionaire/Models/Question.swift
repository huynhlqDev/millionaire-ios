//
//  Question.swift
//  millionaire
//
//  Created by huynh on 18/12/24.
//

import Foundation

struct Question: Codable, Equatable {
    let level: Difficulty
    let question: String
    let answers: [String]
    let correctAnswer: Int
}
