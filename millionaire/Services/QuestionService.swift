//
//  QuestionService.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation

protocol QuestionService {
    func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void)
}

class QuestionServiceManager: QuestionService {
    private let onlineService: QuestionService
    private let offlineService: QuestionService

    init(onlineService: QuestionService, offlineService: QuestionService) {
        self.onlineService = onlineService
        self.offlineService = offlineService
    }

    func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        onlineService.fetchQuestions { [weak self] result in
            switch result {
            case .success(let questions):
                completion(.success(questions))
            case .failure:
                debugLog("Online service failed. Falling back to offline service.")
                self?.offlineService.fetchQuestions(completion: completion)
            }
        }
    }
}
