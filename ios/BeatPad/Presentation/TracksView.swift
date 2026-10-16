import SwiftUI

struct TracksView: View {
    @ObservedObject var audio = AudioEngine.shared
    @State private var playingTrackId: String?

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundDark.edgesIgnoringSafeArea(.all)

                let tracks = audio.recordedTracks.isEmpty ? demoTracks : audio.recordedTracks

                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(tracks) { track in
                            TrackCardItem(
                                track: track,
                                isPlaying: playingTrackId == track.id,
                                onTogglePlay: {
                                    if playingTrackId == track.id {
                                        playingTrackId = nil
                                        audio.stopAll()
                                    } else {
                                        playingTrackId = track.id
                                        audio.playPad(index: 4) // Play bass preview
                                    }
                                }
                            )
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("My Tracks")
        }
    }

    private var demoTracks: [RecordedTrackModel] {
        [
            RecordedTrackModel(id: "1", title: "Neon Trap Freestyle 01", packName: "Neon Trap", date: "Today", duration: "00:45", bpm: 140),
            RecordedTrackModel(id: "2", title: "Cyber EDM Live Jam", packName: "Cyber EDM", date: "Yesterday", duration: "01:20", bpm: 128),
            RecordedTrackModel(id: "3", title: "Deep House Midnight Loop", packName: "Deep House", date: "Oct 14", duration: "00:32", bpm: 124)
        ]
    }
}

struct TrackCardItem: View {
    let track: RecordedTrackModel
    let isPlaying: Bool
    let onTogglePlay: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onTogglePlay) {
                ZStack {
                    Circle()
                        .fill(isPlaying ? AppTheme.neonPink : AppTheme.surfaceElevatedDark)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(isPlaying ? AppTheme.neonPink : AppTheme.borderDark, lineWidth: 1.5)
                        )

                    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isPlaying ? .white : AppTheme.neonCyan)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(track.packName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppTheme.neonCyan)

                    Text("•")
                        .foregroundColor(AppTheme.textSecondary)

                    Text(track.duration)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)

                    Text("•")
                        .foregroundColor(AppTheme.textSecondary)

                    Text("\(track.bpm) BPM")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppTheme.amberAccent)
                }
            }

            Spacer()

            // Waveform bars visual
            HStack(spacing: 2) {
                ForEach(0..<6) { i in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(isPlaying ? AppTheme.neonPink : AppTheme.textSecondary.opacity(0.4))
                        .frame(width: 3, height: isPlaying ? CGFloat(8 + (i * 3 % 16)) : 8)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.surfaceDark)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isPlaying ? AppTheme.neonPink.opacity(0.6) : AppTheme.borderDark, lineWidth: 1)
        )
    }
}
