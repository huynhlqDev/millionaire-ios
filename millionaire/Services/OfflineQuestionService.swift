//
//  OfflineQuestionService.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation

class OfflineQuestionService: QuestionService {
    static let shared = OfflineQuestionService()
    private let fileName: String

    init(fileName: String = "Questions") {
        self.fileName = fileName
    }

    func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            completion(.failure(NSError(domain: "FileNotFound", code: -1, userInfo: nil)))
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)

            // Get 15 random question
            let questionsWithCount =  Array(questions.shuffled().prefix(15))
            completion(.success(questionsWithCount))
        } catch {
            completion(.failure(error))
        }
    }
}

