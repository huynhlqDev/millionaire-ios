//
//  SoundManager.swift
//  millionaire
//
//  Created by huynh on 24/5/25.
//

import Foundation
import AVFoundation

class SoundManager: NSObject {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?
    private var activePlayers: [AVAudioPlayer] = []
    private var completionHandlers: [AVAudioPlayer: () -> Void] = [:]
    private var currentEffectURL: URL?

    enum SoundType: String {
        case welcome = "welcome"
        case ready = "ready"
        case result = "result"
        case gameOver = "game_over"
        case lastGame = "last_game"
        case background1 = "background_1"
        case background2 = "background_2"
        case playing1 = "playing_1"
        case playing2 = "playing_2"
        case playing3 = "playing_3"
        case correct_long = "correct_long"
        case correct_short = "correct_short"
    }

    private override init() {
        super.init()
    }

    func playSound(
        _ type: SoundType,
        loop: Bool = false,
        isEffect: Bool = false,
        onComplete: @escaping (() -> Void) = {}
    ) {

        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "wav") else {
            debugLog("Sound file \(type.rawValue).wav not found.")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.delegate = self
            player.prepareToPlay()
            player.play()

            if isEffect {
                activePlayers.append(player)
                completionHandlers[player] = onComplete
            } else {
                audioPlayer = player
            }
        } catch {
            debugLog("Failed to play sound: \(error.localizedDescription)")
        }
    }

    func stopAll() {
        audioPlayer?.stop()
        for player in activePlayers {
            player.stop()
        }
    }

    func nextEffectLevelUp(onComplete: @escaping (() -> Void)) {
        stopAll()
        playSound(.welcome, isEffect: true) { [weak self] in
            guard let self else { return }
            self.playSound(.ready, isEffect: true, onComplete: onComplete)
        }

    }

    func startPlayingMusic(with currentIndex: Int) {
        debugLog("start playing music")
        stopAll()
        var soundType: SoundType {
            if currentIndex < 4 {
                return .playing1
            } else if currentIndex < 9 {
                return .playing2
            } else {
                return .playing3
            }
        }
        playSound(soundType, loop: true)
    }
}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let handler = completionHandlers[player] {
            handler()
        }

        // Cleanup
        completionHandlers[player] = nil
        if let index = activePlayers.firstIndex(of: player) {
            activePlayers.remove(at: index)
        }
    }
}
