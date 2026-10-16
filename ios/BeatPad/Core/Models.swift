import Foundation
import SwiftUI

enum InstrumentFamily: String, Codable, CaseIterable {
    case drums = "DRUMS"
    case bass = "BASS"
    case synth = "SYNTH"
    case chords = "CHORDS"
    case fx = "FX"
    case vocal = "VOCAL"

    var color: Color {
        switch self {
        case .drums: return AppTheme.familyDrums
        case .bass: return AppTheme.familyBass
        case .synth: return AppTheme.familySynth
        case .chords: return AppTheme.familyChords
        case .fx, .vocal: return AppTheme.familyFxVocal
        }
    }
}

enum PadMode: String, Codable {
    case oneShot = "ONE_SHOT"
    case loop = "LOOP"
}

struct PadModel: Identifiable, Codable {
    let id: Int
    var name: String
    var family: InstrumentFamily
    var mode: PadMode
    var samplePathA: String
    var samplePathB: String
    var colorHex: String
    var loopBars: Int

    var padColor: Color {
        Color(hex: colorHex)
    }

    func currentSample(isSideB: Bool) -> String {
        return isSideB ? samplePathB : samplePathA
    }
}

struct SoundPackModel: Identifiable, Codable {
    let id: String
    let name: String
    let genre: String
    let bpm: Int
    let key: String
    let description: String
    let colorPrimary: String
    let colorSecondary: String
    let demoSample: String
    var pads: [PadModel]

    var primaryColor: Color {
        Color(hex: colorPrimary)
    }
    var secondaryColor: Color {
        Color(hex: colorSecondary)
    }
}

struct LessonStep: Identifiable, Codable {
    var id: Int { step }
    let step: Int
    let padIndex: Int
    let beatTime: Double
}

struct LessonModel: Identifiable, Codable {
    let id: String
    let title: String
    let genre: String
    let bpm: Int
    let difficulty: String
    let description: String
    let steps: [LessonStep]
}

struct RecordedTrackModel: Identifiable, Codable {
    let id: String
    let title: String
    let packName: String
    let date: String
    let duration: String
    let bpm: Int
}
