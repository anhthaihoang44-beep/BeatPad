import SwiftUI

struct SequencerView: View {
    @ObservedObject var audio = AudioEngine.shared

    let trackNames = ["Kick", "Snare", "Closed Hat", "Open Hat", "808 Bass", "Clap", "Lead Synth", "FX"]

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                // Header Control Bar
                HStack(spacing: 12) {
                    Button(action: {
                        audio.toggleSequencer()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: audio.sequencerIsPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 14, weight: .black))
                            Text(audio.sequencerIsPlaying ? "PAUSE" : "PLAY LOOP")
                                .font(.system(size: 13, weight: .heavy))
                        }
                        .foregroundColor(AppTheme.backgroundDark)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(audio.sequencerIsPlaying ? AppTheme.neonPink : AppTheme.neonCyan)
                        .cornerRadius(8)
                    }

                    Spacer()

                    // BPM indicator
                    HStack(spacing: 4) {
                        Text("\(audio.bpm)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(AppTheme.amberAccent)
                        Text("BPM")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(AppTheme.surfaceDark)
                    .cornerRadius(6)

                    // Clear button
                    Button(action: { audio.clearSequencer() }) {
                        Text("CLEAR")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(AppTheme.surfaceDark)
                            .cornerRadius(6)
                    }
                }
                .padding(.horizontal, 16)

                // Step Numbers Header
                HStack(spacing: 0) {
                    Text("TRACK")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(width: 60, alignment: .leading)
                        .padding(.leading, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(0..<16, id: \.self) { step in
                                Text("\(step + 1)")
                                    .font(.system(size: 10, weight: .bold))
                                    .frame(width: 30, height: 20)
                                    .foregroundColor(audio.sequencerCurrentStep == step && audio.sequencerIsPlaying ? AppTheme.neonCyan : (step % 4 == 0 ? .white : AppTheme.textSecondary))
                                    .background(audio.sequencerCurrentStep == step && audio.sequencerIsPlaying ? AppTheme.neonCyan.opacity(0.3) : Color.clear)
                                    .cornerRadius(4)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }

                // Grid of 8 Tracks x 16 Steps
                ScrollView([.vertical, .horizontal], showsIndicators: true) {
                    VStack(spacing: 8) {
                        ForEach(0..<8, id: \.self) { track in
                            HStack(spacing: 0) {
                                // Track Label
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(track < trackNames.count ? trackNames[track] : "Pad \(track + 1)")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }
                                .frame(width: 65, alignment: .leading)
                                .padding(.leading, 8)

                                // 16 Steps Row
                                HStack(spacing: 5) {
                                    ForEach(0..<16, id: \.self) { step in
                                        let isStepActive = audio.sequencerGrid[track][step]
                                        let isPlayhead = (audio.sequencerCurrentStep == step && audio.sequencerIsPlaying)

                                        Button(action: {
                                            audio.toggleSequencerCell(track: track, step: step)
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 6)
                                                    .fill(
                                                        isStepActive
                                                            ? (isPlayhead ? Color.white : AppTheme.neonCyan)
                                                            : (step % 4 == 0 ? AppTheme.surfaceElevatedDark : AppTheme.surfaceDark)
                                                    )
                                                    .frame(width: 30, height: 32)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(
                                                                isPlayhead ? AppTheme.neonPink : (isStepActive ? AppTheme.neonCyan : AppTheme.borderDark),
                                                                lineWidth: isPlayhead ? 2 : 1
                                                            )
                                                    )
                                                    .shadow(
                                                        color: isStepActive ? AppTheme.neonCyan.opacity(0.6) : Color.clear,
                                                        radius: isStepActive ? 4 : 0
                                                    )
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                Spacer()
            }
            .background(AppTheme.backgroundDark.edgesIgnoringSafeArea(.all))
            .navigationTitle("Loop Editor")
        }
    }
}
