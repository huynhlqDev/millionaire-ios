//
//  OnlineQuestionService.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation

class OnlineQuestionService: QuestionService {
    private let apiURL: URL

    init(apiURL: URL) {
        self.apiURL = apiURL
    }

    func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }

            do {
                let questions = try JSONDecoder().decode([Question].self, from: data)
                completion(.success(questions))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
