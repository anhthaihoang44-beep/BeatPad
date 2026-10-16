import SwiftUI

extension Color {
    init(hex: String) {
        let cleanHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 255, 255, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: Double(a) / 255.0
        )
    }
}

struct AppTheme {
    static let backgroundDark = Color(hex: "#15171C")
    static let surfaceDark = Color(hex: "#1E2129")
    static let surfaceElevatedDark = Color(hex: "#282C37")
    static let borderDark = Color(hex: "#333846")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#9EA6B8")

    static let amberAccent = Color(hex: "#FFC83D")
    static let neonPink = Color(hex: "#FF2A6D")
    static let neonCyan = Color(hex: "#05D9E8")
    static let neonPurple = Color(hex: "#9D4EDD")
    static let neonGreen = Color(hex: "#06D6A0")
    static let neonYellow = Color(hex: "#FFD166")
    static let padRecordingRed = Color(hex: "#FF3B30")

    static let familyDrums = Color(hex: "#FF8A3D")
    static let familyBass = Color(hex: "#FF4D8D")
    static let familySynth = Color(hex: "#5CE05C")
    static let familyChords = Color(hex: "#3DA5FF")
    static let familyFxVocal = Color(hex: "#FFD83D")
}
