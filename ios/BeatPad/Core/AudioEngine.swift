import Foundation
import AVFoundation
import UIKit
import Combine

final class AudioEngine: ObservableObject {
    static let shared = AudioEngine()

    private var players: [Int: AVAudioPlayer] = [:]
    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    init() {
        haptic.prepare()
    }

    func loadSample(slot: Int, url: URL) {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            players[slot] = player
        } catch {
            print("Failed to load sample \(slot): \(error)")
        }
    }

    func playPad(slot: Int, hapticEnabled: Bool = true) {
        if hapticEnabled {
            haptic.impactOccurred()
        }
        guard let player = players[slot] else { return }
        if player.isPlaying {
            player.currentTime = 0
        }
        player.play()
    }

    func stopPad(slot: Int) {
        players[slot]?.stop()
    }
}
