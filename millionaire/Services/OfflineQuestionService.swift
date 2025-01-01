//
//  OfflineQuestionService.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation

class OfflineQuestionService: QuestionService {
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
            completion(.success(questions))
        } catch {
            completion(.failure(error))
        }
    }
}

