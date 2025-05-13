//
//  Question.swift
//  millionaire
//
//  Created by huynh on 18/12/24.
//

import Foundation

struct Question: Codable, Equatable {
    let text: String
    let options: [String]
    let correctIndex: Int
}
