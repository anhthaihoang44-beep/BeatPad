import SwiftUI

struct PacksLibraryView: View {
    @ObservedObject var audio = AudioEngine.shared
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(SoundPackManager.shared.allPacks) { pack in
                        PackCardView(
                            pack: pack,
                            isActive: audio.currentPack.id == pack.id,
                            onSelect: {
                                audio.loadPack(id: pack.id)
                                selectedTab = 1 // Switch to Play Tab
                            }
                        )
                    }
                }
                .padding(16)
            }
            .background(AppTheme.backgroundDark.edgesIgnoringSafeArea(.all))
            .navigationTitle("Sound Packs")
        }
    }
}

struct PackCardView: View {
    let pack: SoundPackModel
    let isActive: Bool
    let onSelect: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(pack.name)
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)

                        Text(pack.genre)
                            .font(.system(size: 11, weight: .heavy))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(pack.primaryColor.opacity(0.3))
                            .foregroundColor(pack.primaryColor)
                            .cornerRadius(6)
                    }

                    HStack(spacing: 12) {
                        Label("\(pack.bpm) BPM", systemImage: "metronome")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)

                        Label(pack.key, systemImage: "music.note")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }

                Spacer()

                if isActive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(AppTheme.neonCyan)
                            .frame(width: 8, height: 8)
                        Text("ACTIVE")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(AppTheme.neonCyan)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(AppTheme.neonCyan.opacity(0.15))
                    .cornerRadius(8)
                }
            }

            Text(pack.description)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)

            HStack {
                Spacer()

                Button(action: onSelect) {
                    HStack(spacing: 6) {
                        Image(systemName: isActive ? "checkmark.circle.fill" : "play.fill")
                        Text(isActive ? "PLAYING" : "LOAD PACK")
                    }
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(isActive ? AppTheme.backgroundDark : .white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(isActive ? AppTheme.neonCyan : pack.primaryColor)
                    .cornerRadius(10)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            pack.primaryColor.opacity(isActive ? 0.25 : 0.12),
                            AppTheme.surfaceDark
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isActive ? AppTheme.neonCyan : pack.primaryColor.opacity(0.4),
                    lineWidth: isActive ? 2 : 1
                )
        )
    }
}
