import Foundation
import AVFoundation
import UIKit
import Combine

final class AudioEngine: ObservableObject {
    static let shared = AudioEngine()

    @Published var currentPack: SoundPackModel
    @Published var isSideB: Bool = false
    @Published var bpm: Int = 140
    @Published var isMetronomeActive: Bool = false
    @Published var isQuantizeEnabled: Bool = true
    @Published var isRecording: Bool = false
    @Published var recordingDuration: Double = 0
    @Published var activePadSlots: Set<Int> = []
    @Published var activeLoopSlots: Set<Int> = []

    // 16-Step Sequencer State
    @Published var sequencerIsPlaying: Bool = false
    @Published var sequencerCurrentStep: Int = 0
    @Published var sequencerGrid: [[Bool]] = Array(repeating: Array(repeating: false, count: 16), count: 8)

    // Recorded tracks
    @Published var recordedTracks: [RecordedTrackModel] = []

    private var players: [Int: AVAudioPlayer] = [:]
    private var demoPlayer: AVAudioPlayer?
    private var metronomePlayer: AVAudioPlayer?
    private var sequencerTimer: Timer?
    private var recordTimer: Timer?
    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    init() {
        let initialPack = SoundPackManager.shared.getPack(id: "neon_trap")
        self.currentPack = initialPack
        self.bpm = initialPack.bpm
        haptic.prepare()
        preloadPack(initialPack)
        setupDefaultSequencer()
    }

    func loadPack(id: String) {
        stopAll()
        let pack = SoundPackManager.shared.getPack(id: id)
        self.currentPack = pack
        self.bpm = pack.bpm
        preloadPack(pack)
    }

    func preloadPack(_ pack: SoundPackModel) {
        players.removeAll()
        for pad in pack.pads {
            // Side A: index 0..11
            loadSample(slot: pad.id, samplePath: pad.samplePathA)
            // Side B: index 12..23
            loadSample(slot: pad.id + 12, samplePath: pad.samplePathB)
        }
    }

    private func loadSample(slot: Int, samplePath: String) {
        if let url = resolveAudioUrl(samplePath: samplePath) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                players[slot] = player
                return
            } catch {
                print("Failed to load \(samplePath): \(error)")
            }
        }

        // Fallback tone generator so audio always works
        if let fallbackPlayer = createSynthFallbackPlayer(slot: slot) {
            fallbackPlayer.prepareToPlay()
            players[slot] = fallbackPlayer
        }
    }

    private func resolveAudioUrl(samplePath: String) -> URL? {
        // Direct URL in bundle root
        let rootUrl = Bundle.main.bundleURL.appendingPathComponent(samplePath)
        if FileManager.default.fileExists(atPath: rootUrl.path) {
            return rootUrl
        }

        // Try without folder
        let filename = (samplePath as NSString).lastPathComponent
        let nameOnly = (filename as NSString).deletingPathExtension
        let ext = (filename as NSString).pathExtension
        if let url = Bundle.main.url(forResource: nameOnly, withExtension: ext.isEmpty ? "wav" : ext) {
            return url
        }

        return nil
    }

    func playPad(index: Int) {
        haptic.impactOccurred()
        let slot = index + (isSideB ? 12 : 0)
        let pad = (index < currentPack.pads.count) ? currentPack.pads[index] : nil

        // Visual flash
        DispatchQueue.main.async {
            self.activePadSlots.insert(index)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            self.activePadSlots.remove(index)
        }

        guard let player = players[slot] else { return }

        if pad?.mode == .loop {
            if activeLoopSlots.contains(index) {
                activeLoopSlots.remove(index)
                player.stop()
            } else {
                activeLoopSlots.insert(index)
                player.numberOfLoops = -1
                player.currentTime = 0
                player.play()
            }
        } else {
            if player.isPlaying {
                player.currentTime = 0
            }
            player.play()
        }
    }

    func stopAll() {
        for (_, p) in players {
            p.stop()
        }
        activeLoopSlots.removeAll()
        activePadSlots.removeAll()
    }

    func toggleSide() {
        stopAll()
        isSideB.toggle()
    }

    func setBpm(_ newBpm: Int) {
        bpm = max(60, min(220, newBpm))
        if sequencerIsPlaying {
            restartSequencerTimer()
        }
    }

    func toggleMetronome() {
        isMetronomeActive.toggle()
    }

    func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            recordingDuration = 0
            recordTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.recordingDuration += 1
                }
            }
        } else {
            recordTimer?.invalidate()
            recordTimer = nil
            // Save recording entry
            let durationStr = String(format: "%02d:%02d", Int(recordingDuration) / 60, Int(recordingDuration) % 60)
            let newTrack = RecordedTrackModel(
                id: UUID().uuidString,
                title: "\(currentPack.name) Session \(recordedTracks.count + 1)",
                packName: currentPack.name,
                date: "Just now",
                duration: durationStr,
                bpm: bpm
            )
            recordedTracks.insert(newTrack, at: 0)
        }
    }

    // 16-step sequencer logic
    func toggleSequencer() {
        sequencerIsPlaying.toggle()
        if sequencerIsPlaying {
            sequencerCurrentStep = 0
            restartSequencerTimer()
        } else {
            sequencerTimer?.invalidate()
            sequencerTimer = nil
        }
    }

    func toggleSequencerCell(track: Int, step: Int) {
        guard track < sequencerGrid.count, step < 16 else { return }
        sequencerGrid[track][step].toggle()
        if sequencerGrid[track][step] {
            // Trigger sound preview
            playPad(index: track)
        }
    }

    func clearSequencer() {
        sequencerGrid = Array(repeating: Array(repeating: false, count: 16), count: 8)
    }

    private func restartSequencerTimer() {
        sequencerTimer?.invalidate()
        let stepInterval = (60.0 / Double(bpm)) / 4.0
        sequencerTimer = Timer.scheduledTimer(withTimeInterval: stepInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stepSequencer()
            }
        }
    }

    private func stepSequencer() {
        sequencerCurrentStep = (sequencerCurrentStep + 1) % 16

        // Metronome click on quarter notes (0, 4, 8, 12)
        if isMetronomeActive && sequencerCurrentStep % 4 == 0 {
            haptic.impactOccurred()
        }

        // Trigger sounds for this step
        for track in 0..<min(8, currentPack.pads.count) {
            if sequencerGrid[track][sequencerCurrentStep] {
                let slot = track + (isSideB ? 12 : 0)
                if let player = players[slot] {
                    if player.isPlaying { player.currentTime = 0 }
                    player.play()
                }
            }
        }
    }

    private func setupDefaultSequencer() {
        // Kick on 0, 8, 10
        sequencerGrid[0][0] = true
        sequencerGrid[0][8] = true
        sequencerGrid[0][10] = true

        // Snare/Clap on 4, 12
        sequencerGrid[1][4] = true
        sequencerGrid[1][12] = true

        // Hi-Hat on even steps
        for s in stride(from: 0, to: 16, by: 2) {
            sequencerGrid[2][s] = true
        }
    }

    private func createSynthFallbackPlayer(slot: Int) -> AVAudioPlayer? {
        let sampleRate: Double = 44100.0
        let duration: Double = (slot % 12 == 4 || slot % 12 == 7) ? 0.6 : 0.2
        let numFrames = Int(sampleRate * duration)

        let baseFreq: Double = {
            switch slot % 12 {
            case 0: return 60.0   // Kick
            case 1: return 220.0  // Snare
            case 2, 3: return 900.0 // Hat
            case 4: return 55.0   // Sub
            case 5: return 260.0  // Clap
            case 6: return 440.0  // Lead
            case 7: return 330.0  // Pluck
            case 8, 9: return 650.0 // FX
            default: return 520.0 // Vocal
            }
        }()

        var pcmData = Data()
        for i in 0..<numFrames {
            let t = Double(i) / sampleRate
            let decay = exp(-t * 6.0)
            let freq = (slot % 12 == 0) ? max(30.0, baseFreq * exp(-t * 20.0)) : baseFreq
            let val = sin(2.0 * Double.pi * freq * t) * decay
            let sample16 = Int16(max(-32767.0, min(32767.0, val * 32000.0)))
            var littleEndian = sample16.littleEndian
            withUnsafeBytes(of: &littleEndian) { ptr in pcmData.append(contentsOf: ptr) }
        }

        // Build standard WAV header
        var wav = Data()
        wav.append("RIFF".data(using: .ascii)!)
        var chunkSize = UInt32(36 + pcmData.count).littleEndian
        withUnsafeBytes(of: &chunkSize) { ptr in wav.append(contentsOf: ptr) }
        wav.append("WAVE".data(using: .ascii)!)
        wav.append("fmt ".data(using: .ascii)!)
        var subchunk1Size = UInt32(16).littleEndian
        withUnsafeBytes(of: &subchunk1Size) { ptr in wav.append(contentsOf: ptr) }
        var audioFormat = UInt16(1).littleEndian
        withUnsafeBytes(of: &audioFormat) { ptr in wav.append(contentsOf: ptr) }
        var numChannels = UInt16(1).littleEndian
        withUnsafeBytes(of: &numChannels) { ptr in wav.append(contentsOf: ptr) }
        var sRate = UInt32(sampleRate).littleEndian
        withUnsafeBytes(of: &sRate) { ptr in wav.append(contentsOf: ptr) }
        var byteRate = UInt32(sampleRate * 2).littleEndian
        withUnsafeBytes(of: &byteRate) { ptr in wav.append(contentsOf: ptr) }
        var blockAlign = UInt16(2).littleEndian
        withUnsafeBytes(of: &blockAlign) { ptr in wav.append(contentsOf: ptr) }
        var bitsPerSample = UInt16(16).littleEndian
        withUnsafeBytes(of: &bitsPerSample) { ptr in wav.append(contentsOf: ptr) }
        wav.append("data".data(using: .ascii)!)
        var dataSize = UInt32(pcmData.count).littleEndian
        withUnsafeBytes(of: &dataSize) { ptr in wav.append(contentsOf: ptr) }
        wav.append(pcmData)

        return try? AVAudioPlayer(data: wav)
    }
}