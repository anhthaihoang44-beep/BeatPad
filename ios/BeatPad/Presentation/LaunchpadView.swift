import SwiftUI

struct LaunchpadView: View {
    @ObservedObject var audio = AudioEngine.shared
    @State private var isSideB = false
    @State private var bpm: Int = 140
    @State private var isRecording = false

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Neon Trap")
                        .font(.title2).bold()
                    Text(isSideB ? "Trap • Side B" : "Trap • Side A")
                        .font(.caption).foregroundColor(.gray)
                }
                Spacer()
                Button(action: { isSideB.toggle() }) {
                    Text(isSideB ? "SIDE B" : "SIDE A")
                        .font(.caption).bold()
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            // 4x3 Pad Grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<12) { index in
                    PadButton(index: index, isSideB: isSideB)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .background(Color(white: 0.08).edgesIgnoringSafeArea(.all))
    }
}

struct PadButton: View {
    let index: Int
    let isSideB: Bool
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            AudioEngine.shared.playPad(slot: index + (isSideB ? 12 : 0))
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(padColor.opacity(isPressed ? 1.0 : 0.8))
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(padColor, lineWidth: isPressed ? 3 : 1)
                    )
                    .scaleEffect(isPressed ? 0.96 : 1.0)

                VStack {
                    Text("Pad \(index + 1)")
                        .font(.subheadline).bold()
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var padColor: Color {
        switch index {
        case 0...4: return .orange
        case 5: return .pink
        case 6...8: return .green
        case 9: return .blue
        default: return .yellow
        }
    }
}
