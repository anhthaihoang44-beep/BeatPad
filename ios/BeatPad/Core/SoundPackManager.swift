import Foundation

final class SoundPackManager {
    static let shared = SoundPackManager()

    var allPacks: [SoundPackModel] = []

    init() {
        allPacks = createBuiltInPacks()
    }

    func getPack(id: String) -> SoundPackModel {
        if let found = allPacks.first(where: { $0.id == id }) {
            return found
        }
        return allPacks[0]
    }

    private func createBuiltInPacks() -> [SoundPackModel] {
        return [
            SoundPackModel(
                id: "neon_trap",
                name: "Neon Trap",
                genre: "Trap",
                bpm: 140,
                key: "F Minor",
                description: "Heavy 808 sub drops, razor-sharp hats, and energetic vocal chops.",
                colorPrimary: "#FF2A6D",
                colorSecondary: "#05D9E8",
                demoSample: "samples/trap/pad_4.wav",
                pads: [
                    PadModel(id: 0, name: "Kick 808", family: .drums, mode: .oneShot, samplePathA: "samples/trap/pad_0.wav", samplePathB: "samples/trap/pad_0.wav", colorHex: "#FF2A6D", loopBars: 1),
                    PadModel(id: 1, name: "Trap Snare", family: .drums, mode: .oneShot, samplePathA: "samples/trap/pad_1.wav", samplePathB: "samples/trap/pad_1.wav", colorHex: "#FF2A6D", loopBars: 1),
                    PadModel(id: 2, name: "Closed Hat", family: .drums, mode: .oneShot, samplePathA: "samples/trap/pad_2.wav", samplePathB: "samples/trap/pad_2.wav", colorHex: "#FF5376", loopBars: 1),
                    PadModel(id: 3, name: "Open Hat", family: .drums, mode: .oneShot, samplePathA: "samples/trap/pad_3.wav", samplePathB: "samples/trap/pad_3.wav", colorHex: "#FF5376", loopBars: 1),
                    PadModel(id: 4, name: "Sub 808", family: .bass, mode: .loop, samplePathA: "samples/trap/pad_4.wav", samplePathB: "samples/trap/pad_4.wav", colorHex: "#05D9E8", loopBars: 2),
                    PadModel(id: 5, name: "Trap Clap", family: .drums, mode: .oneShot, samplePathA: "samples/trap/pad_5.wav", samplePathB: "samples/trap/pad_5.wav", colorHex: "#FF2A6D", loopBars: 1),
                    PadModel(id: 6, name: "Brass Stab", family: .synth, mode: .oneShot, samplePathA: "samples/trap/pad_6.wav", samplePathB: "samples/trap/pad_6.wav", colorHex: "#9D4EDD", loopBars: 1),
                    PadModel(id: 7, name: "Synth Pluck", family: .synth, mode: .loop, samplePathA: "samples/trap/pad_7.wav", samplePathB: "samples/trap/pad_7.wav", colorHex: "#B5179E", loopBars: 2),
                    PadModel(id: 8, name: "Laser FX", family: .fx, mode: .oneShot, samplePathA: "samples/trap/pad_8.wav", samplePathB: "samples/trap/pad_8.wav", colorHex: "#FFD166", loopBars: 1),
                    PadModel(id: 9, name: "Riser Build", family: .fx, mode: .oneShot, samplePathA: "samples/trap/pad_9.wav", samplePathB: "samples/trap/pad_9.wav", colorHex: "#FFD166", loopBars: 2),
                    PadModel(id: 10, name: "Vocal Hey", family: .vocal, mode: .oneShot, samplePathA: "samples/trap/pad_10.wav", samplePathB: "samples/trap/pad_10.wav", colorHex: "#06D6A0", loopBars: 1),
                    PadModel(id: 11, name: "Vocal Chant", family: .vocal, mode: .oneShot, samplePathA: "samples/trap/pad_11.wav", samplePathB: "samples/trap/pad_11.wav", colorHex: "#06D6A0", loopBars: 1)
                ]
            ),
            SoundPackModel(
                id: "cyber_edm",
                name: "Cyber EDM",
                genre: "EDM",
                bpm: 128,
                key: "A Minor",
                description: "Punchy mainstage festival drops, laser synths, and driving basslines.",
                colorPrimary: "#00F0FF",
                colorSecondary: "#7928CA",
                demoSample: "samples/edm/pad_4.wav",
                pads: [
                    PadModel(id: 0, name: "Punch Kick", family: .drums, mode: .oneShot, samplePathA: "samples/edm/pad_0.wav", samplePathB: "samples/edm/pad_0.wav", colorHex: "#00F0FF", loopBars: 1),
                    PadModel(id: 1, name: "Club Snare", family: .drums, mode: .oneShot, samplePathA: "samples/edm/pad_1.wav", samplePathB: "samples/edm/pad_1.wav", colorHex: "#00F0FF", loopBars: 1),
                    PadModel(id: 2, name: "Short Hat", family: .drums, mode: .oneShot, samplePathA: "samples/edm/pad_2.wav", samplePathB: "samples/edm/pad_2.wav", colorHex: "#00D4FF", loopBars: 1),
                    PadModel(id: 3, name: "Ride Cymbal", family: .drums, mode: .oneShot, samplePathA: "samples/edm/pad_3.wav", samplePathB: "samples/edm/pad_3.wav", colorHex: "#00D4FF", loopBars: 1),
                    PadModel(id: 4, name: "Main Bass", family: .bass, mode: .loop, samplePathA: "samples/edm/pad_4.wav", samplePathB: "samples/edm/pad_4.wav", colorHex: "#7928CA", loopBars: 2),
                    PadModel(id: 5, name: "Big Clap", family: .drums, mode: .oneShot, samplePathA: "samples/edm/pad_5.wav", samplePathB: "samples/edm/pad_5.wav", colorHex: "#00F0FF", loopBars: 1),
                    PadModel(id: 6, name: "Festival Lead", family: .synth, mode: .oneShot, samplePathA: "samples/edm/pad_6.wav", samplePathB: "samples/edm/pad_6.wav", colorHex: "#FF007A", loopBars: 1),
                    PadModel(id: 7, name: "Saw Loop", family: .synth, mode: .loop, samplePathA: "samples/edm/pad_7.wav", samplePathB: "samples/edm/pad_7.wav", colorHex: "#FF007A", loopBars: 2),
                    PadModel(id: 8, name: "Impact Sweep", family: .fx, mode: .oneShot, samplePathA: "samples/edm/pad_8.wav", samplePathB: "samples/edm/pad_8.wav", colorHex: "#FFD166", loopBars: 1),
                    PadModel(id: 9, name: "EDM Siren", family: .fx, mode: .oneShot, samplePathA: "samples/edm/pad_9.wav", samplePathB: "samples/edm/pad_9.wav", colorHex: "#FFD166", loopBars: 2),
                    PadModel(id: 10, name: "Crowd Drop", family: .vocal, mode: .oneShot, samplePathA: "samples/edm/pad_10.wav", samplePathB: "samples/edm/pad_10.wav", colorHex: "#06D6A0", loopBars: 1),
                    PadModel(id: 11, name: "Vocal Yeah", family: .vocal, mode: .oneShot, samplePathA: "samples/edm/pad_11.wav", samplePathB: "samples/edm/pad_11.wav", colorHex: "#06D6A0", loopBars: 1)
                ]
            ),
            SoundPackModel(
                id: "deep_house",
                name: "Deep House",
                genre: "House",
                bpm: 124,
                key: "C Minor",
                description: "Deep rolling sub bass, warm rhodes chords, and shuffle groove percussion.",
                colorPrimary: "#FF8A00",
                colorSecondary: "#E52E71",
                demoSample: "samples/house/pad_4.wav",
                pads: [
                    PadModel(id: 0, name: "House Kick", family: .drums, mode: .oneShot, samplePathA: "samples/house/pad_0.wav", samplePathB: "samples/house/pad_0.wav", colorHex: "#FF8A00", loopBars: 1),
                    PadModel(id: 1, name: "Deep Clap", family: .drums, mode: .oneShot, samplePathA: "samples/house/pad_1.wav", samplePathB: "samples/house/pad_1.wav", colorHex: "#FF8A00", loopBars: 1),
                    PadModel(id: 2, name: "Groove Hat", family: .drums, mode: .oneShot, samplePathA: "samples/house/pad_2.wav", samplePathB: "samples/house/pad_2.wav", colorHex: "#FFA834", loopBars: 1),
                    PadModel(id: 3, name: "Shaker Loop", family: .drums, mode: .oneShot, samplePathA: "samples/house/pad_3.wav", samplePathB: "samples/house/pad_3.wav", colorHex: "#FFA834", loopBars: 1),
                    PadModel(id: 4, name: "Donk Bass", family: .bass, mode: .loop, samplePathA: "samples/house/pad_4.wav", samplePathB: "samples/house/pad_4.wav", colorHex: "#E52E71", loopBars: 2),
                    PadModel(id: 5, name: "Rimshot", family: .drums, mode: .oneShot, samplePathA: "samples/house/pad_5.wav", samplePathB: "samples/house/pad_5.wav", colorHex: "#FF8A00", loopBars: 1),
                    PadModel(id: 6, name: "M1 Organ", family: .chords, mode: .oneShot, samplePathA: "samples/house/pad_6.wav", samplePathB: "samples/house/pad_6.wav", colorHex: "#3DA5FF", loopBars: 1),
                    PadModel(id: 7, name: "House Stabs", family: .chords, mode: .loop, samplePathA: "samples/house/pad_7.wav", samplePathB: "samples/house/pad_7.wav", colorHex: "#3DA5FF", loopBars: 2),
                    PadModel(id: 8, name: "Vinyl Crackle", family: .fx, mode: .oneShot, samplePathA: "samples/house/pad_8.wav", samplePathB: "samples/house/pad_8.wav", colorHex: "#FFD166", loopBars: 1),
                    PadModel(id: 9, name: "Sub Drop", family: .fx, mode: .oneShot, samplePathA: "samples/house/pad_9.wav", samplePathB: "samples/house/pad_9.wav", colorHex: "#FFD166", loopBars: 2),
                    PadModel(id: 10, name: "Soul Vocal", family: .vocal, mode: .oneShot, samplePathA: "samples/house/pad_10.wav", samplePathB: "samples/house/pad_10.wav", colorHex: "#06D6A0", loopBars: 1),
                    PadModel(id: 11, name: "Groove Vocal", family: .vocal, mode: .oneShot, samplePathA: "samples/house/pad_11.wav", samplePathB: "samples/house/pad_11.wav", colorHex: "#06D6A0", loopBars: 1)
                ]
            ),
            SoundPackModel(
                id: "cyber_dubstep",
                name: "Cyber Dubstep",
                genre: "Dubstep",
                bpm: 145,
                key: "D Minor",
                description: "Aggressive growl basses, gunshot snares, and cybernetic screech leads.",
                colorPrimary: "#FF0055",
                colorSecondary: "#00FFCC",
                demoSample: "samples/dubstep/pad_4.wav",
                pads: [
                    PadModel(id: 0, name: "Heavy Kick", family: .drums, mode: .oneShot, samplePathA: "samples/dubstep/pad_0.wav", samplePathB: "samples/dubstep/pad_0.wav", colorHex: "#FF0055", loopBars: 1),
                    PadModel(id: 1, name: "Gunshot Snare", family: .drums, mode: .oneShot, samplePathA: "samples/dubstep/pad_1.wav", samplePathB: "samples/dubstep/pad_1.wav", colorHex: "#FF0055", loopBars: 1),
                    PadModel(id: 2, name: "Sharp Hat", family: .drums, mode: .oneShot, samplePathA: "samples/dubstep/pad_2.wav", samplePathB: "samples/dubstep/pad_2.wav", colorHex: "#FF3377", loopBars: 1),
                    PadModel(id: 3, name: "Metal Crash", family: .drums, mode: .oneShot, samplePathA: "samples/dubstep/pad_3.wav", samplePathB: "samples/dubstep/pad_3.wav", colorHex: "#FF3377", loopBars: 1),
                    PadModel(id: 4, name: "Growl Bass", family: .bass, mode: .loop, samplePathA: "samples/dubstep/pad_4.wav", samplePathB: "samples/dubstep/pad_4.wav", colorHex: "#00FFCC", loopBars: 2),
                    PadModel(id: 5, name: "Clap Punch", family: .drums, mode: .oneShot, samplePathA: "samples/dubstep/pad_5.wav", samplePathB: "samples/dubstep/pad_5.wav", colorHex: "#FF0055", loopBars: 1),
                    PadModel(id: 6, name: "Screech Lead", family: .synth, mode: .oneShot, samplePathA: "samples/dubstep/pad_6.wav", samplePathB: "samples/dubstep/pad_6.wav", colorHex: "#9D4EDD", loopBars: 1),
                    PadModel(id: 7, name: "Wobble Loop", family: .synth, mode: .loop, samplePathA: "samples/dubstep/pad_7.wav", samplePathB: "samples/dubstep/pad_7.wav", colorHex: "#9D4EDD", loopBars: 2),
                    PadModel(id: 8, name: "Glitch Zap", family: .fx, mode: .oneShot, samplePathA: "samples/dubstep/pad_8.wav", samplePathB: "samples/dubstep/pad_8.wav", colorHex: "#FFD166", loopBars: 1),
                    PadModel(id: 9, name: "Downlifter", family: .fx, mode: .oneShot, samplePathA: "samples/dubstep/pad_9.wav", samplePathB: "samples/dubstep/pad_9.wav", colorHex: "#FFD166", loopBars: 2),
                    PadModel(id: 10, name: "Cyber Shouts", family: .vocal, mode: .oneShot, samplePathA: "samples/dubstep/pad_10.wav", samplePathB: "samples/dubstep/pad_10.wav", colorHex: "#06D6A0", loopBars: 1),
                    PadModel(id: 11, name: "Vocoder Drop", family: .vocal, mode: .oneShot, samplePathA: "samples/dubstep/pad_11.wav", samplePathB: "samples/dubstep/pad_11.wav", colorHex: "#06D6A0", loopBars: 1)
                ]
            ),
            SoundPackModel(
                id: "future_bass",
                name: "Future Bass",
                genre: "Future Bass",
                bpm: 150,
                key: "E Minor",
                description: "Supersaw lush chords, pitch-bent vocal chops, and bouncy trap percussion.",
                colorPrimary: "#B5179E",
                colorSecondary: "#7209B7",
                demoSample: "samples/futurebass/pad_4.wav",
                pads: [
                    PadModel(id: 0, name: "Sub Kick", family: .drums, mode: .oneShot, samplePathA: "samples/futurebass/pad_0.wav", samplePathB: "samples/futurebass/pad_0.wav", colorHex: "#B5179E", loopBars: 1),
                    PadModel(id: 1, name: "Future Snare", family: .drums, mode: .oneShot, samplePathA: "samples/futurebass/pad_1.wav", samplePathB: "samples/futurebass/pad_1.wav", colorHex: "#B5179E", loopBars: 1),
                    PadModel(id: 2, name: "Lofi Hat", family: .drums, mode: .oneShot, samplePathA: "samples/futurebass/pad_2.wav", samplePathB: "samples/futurebass/pad_2.wav", colorHex: "#C77DFF", loopBars: 1),
                    PadModel(id: 3, name: "Splash Hat", family: .drums, mode: .oneShot, samplePathA: "samples/futurebass/pad_3.wav", samplePathB: "samples/futurebass/pad_3.wav", colorHex: "#C77DFF", loopBars: 1),
                    PadModel(id: 4, name: "Sidechain Saw", family: .synth, mode: .loop, samplePathA: "samples/futurebass/pad_4.wav", samplePathB: "samples/futurebass/pad_4.wav", colorHex: "#7209B7", loopBars: 2),
                    PadModel(id: 5, name: "Snap Clap", family: .drums, mode: .oneShot, samplePathA: "samples/futurebass/pad_5.wav", samplePathB: "samples/futurebass/pad_5.wav", colorHex: "#B5179E", loopBars: 1),
                    PadModel(id: 6, name: "Glitz Arp", family: .synth, mode: .oneShot, samplePathA: "samples/futurebass/pad_6.wav", samplePathB: "samples/futurebass/pad_6.wav", colorHex: "#FF007A", loopBars: 1),
                    PadModel(id: 7, name: "Lush Chords", family: .chords, mode: .loop, samplePathA: "samples/futurebass/pad_7.wav", samplePathB: "samples/futurebass/pad_7.wav", colorHex: "#FF007A", loopBars: 2),
                    PadModel(id: 8, name: "Chime FX", family: .fx, mode: .oneShot, samplePathA: "samples/futurebass/pad_8.wav", samplePathB: "samples/futurebass/pad_8.wav", colorHex: "#FFD166", loopBars: 1),
                    PadModel(id: 9, name: "White Riser", family: .fx, mode: .oneShot, samplePathA: "samples/futurebass/pad_9.wav", samplePathB: "samples/futurebass/pad_9.wav", colorHex: "#FFD166", loopBars: 2),
                    PadModel(id: 10, name: "Vocal Oh", family: .vocal, mode: .oneShot, samplePathA: "samples/futurebass/pad_10.wav", samplePathB: "samples/futurebass/pad_10.wav", colorHex: "#06D6A0", loopBars: 1),
                    PadModel(id: 11, name: "Vocal Baby", family: .vocal, mode: .oneShot, samplePathA: "samples/futurebass/pad_11.wav", samplePathB: "samples/futurebass/pad_11.wav", colorHex: "#06D6A0", loopBars: 1)
                ]
            ),
            SoundPackModel(
                id: "neuro_dnb",
                name: "Neuro DnB",
                genre: "DnB",
                bpm: 174,
                key: "F Minor",
                description: "Lightning-fast breakbeats, reese bass filtering, and intense dark atmospheric pads.",
                colorPrimary: "#F72585",
                colorSecondary: "#4CC9F0",
                demoSample: "samples/dnb/pad_4.wav",
                pads: [
                    PadModel(id: 0, name: "Fast Kick", family: .drums, mode: .oneShot, samplePathA: "samples/dnb/pad_0.wav", samplePathB: "samples/dnb/pad_0.wav", colorHex: "#F72585", loopBars: 1),
                    PadModel(id: 1, name: "Ghost Snare", family: .drums, mode: .oneShot, samplePathA: "samples/dnb/pad_1.wav", samplePathB: "samples/dnb/pad_1.wav", colorHex: "#F72585", loopBars: 1),
                    PadModel(id: 2, name: "Roll Hat", family: .drums, mode: .oneShot, samplePathA: "samples/dnb/pad_2.wav", samplePathB: "samples/dnb/pad_2.wav", colorHex: "#B5179E", loopBars: 1),
                    PadModel(id: 3, name: "Tambourine", family: .drums, mode: .oneShot, samplePathA: "samples/dnb/pad_3.wav", samplePathB: "samples/dnb/pad_3.wav", colorHex: "#B5179E", loopBars: 1),
                    PadModel(id: 4, name: "Reese Bass", family: .bass, mode: .loop, samplePathA: "samples/dnb/pad_4.wav", samplePathB: "samples/dnb/pad_4.wav", colorHex: "#4CC9F0", loopBars: 2),
                    PadModel(id: 5, name: "Break Rim", family: .drums, mode: .oneShot, samplePathA: "samples/dnb/pad_5.wav", samplePathB: "samples/dnb/pad_5.wav", colorHex: "#F72585", loopBars: 1),
                    PadModel(id: 6, name: "Tech Synth", family: .synth, mode: .oneShot, samplePathA: "samples/dnb/pad_6.wav", samplePathB: "samples/dnb/pad_6.wav", colorHex: "#7209B7", loopBars: 1),
                    PadModel(id: 7, name: "Dark Pad", family: .synth, mode: .loop, samplePathA: "samples/dnb/pad_7.wav", samplePathB: "samples/dnb/pad_7.wav", colorHex: "#7209B7", loopBars: 2),
                    PadModel(id: 8, name: "Sub Impact", family: .fx, mode: .oneShot, samplePathA: "samples/dnb/pad_8.wav", samplePathB: "samples/dnb/pad_8.wav", colorHex: "#FFD166", loopBars: 1),
                    PadModel(id: 9, name: "Tension Riser", family: .fx, mode: .oneShot, samplePathA: "samples/dnb/pad_9.wav", samplePathB: "samples/dnb/pad_9.wav", colorHex: "#FFD166", loopBars: 2),
                    PadModel(id: 10, name: "Rave Vocal", family: .vocal, mode: .oneShot, samplePathA: "samples/dnb/pad_10.wav", samplePathB: "samples/dnb/pad_10.wav", colorHex: "#06D6A0", loopBars: 1),
                    PadModel(id: 11, name: "Bass Growl", family: .vocal, mode: .oneShot, samplePathA: "samples/dnb/pad_11.wav", samplePathB: "samples/dnb/pad_11.wav", colorHex: "#06D6A0", loopBars: 1)
                ]
            )
        ]
    }
}
