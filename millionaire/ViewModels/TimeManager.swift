//
//  TimeManager.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation

class TimeManager: ObservableObject {
    static let shared = TimeManager()

    // MARK: - Properties
    @Published var remainingTime: TimeInterval

    private var timer: Timer?
    private var duration: TimeInterval = 30
    private var isPaused: Bool = false

    var onTick: ((TimeInterval) -> Void)?
    var onFinish: (() -> Void)?

    // MARK: - Initialization
    init() {
        self.remainingTime = duration
    }

    // MARK: - Methods

    /// Starts the timer
    func start() {
        guard timer == nil else { return } // Avoid multiple timers
        isPaused = false
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true
        )
    }

    func restart() {
        stop()
        remainingTime = duration
        start()
    }

    /// Pauses the timer
    func pause() {
        guard !isPaused else { return }
        isPaused = true
        timer?.invalidate()
        timer = nil
    }

    /// Resumes the timer
    func resume() {
        guard isPaused else { return }
        isPaused = false
        start()
    }

    /// Stops the timer and resets it
    func stop() {
        timer?.invalidate()
        timer = nil
        remainingTime = duration
        isPaused = false
    }

    /// Adjusts the remaining time (e.g., for bonuses or penalties)
    func adjustTime(by adjustment: TimeInterval) {
        remainingTime = max(0, remainingTime + adjustment)
    }

    // MARK: - Timer Tick
    @objc private func timerTick() {
        guard remainingTime > 0 else {
            timer?.invalidate()
            timer = nil
            onFinish?()
            return
        }

        remainingTime -= 1
        onTick?(remainingTime)
    }
}
