import SwiftUI

struct LaunchpadView: View {
    @ObservedObject var audio = AudioEngine.shared
    @Binding var selectedTab: Int

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        VStack(spacing: 12) {
            // Header Bar
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(audio.currentPack.name)
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)

                        Text(audio.currentPack.genre)
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(audio.currentPack.primaryColor.opacity(0.3))
                            .foregroundColor(audio.currentPack.primaryColor)
                            .cornerRadius(4)
                    }

                    HStack(spacing: 8) {
                        Text("\(audio.bpm) BPM")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)

                        Text("•")
                            .foregroundColor(AppTheme.textSecondary)

                        Text(audio.currentPack.key)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }

                Spacer()

                // Side A / Side B Toggle Button
                Button(action: {
                    audio.toggleSide()
                }) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(audio.isSideB ? AppTheme.neonPink : AppTheme.neonCyan)
                            .frame(width: 8, height: 8)

                        Text(audio.isSideB ? "SIDE B" : "SIDE A")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.surfaceElevatedDark)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(audio.isSideB ? AppTheme.neonPink : AppTheme.neonCyan, lineWidth: 1.5)
                            )
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // Control Bar
            HStack(spacing: 8) {
                // BPM Controls
                HStack(spacing: 4) {
                    Button(action: { audio.setBpm(audio.bpm - 2) }) {
                        Image(systemName: "minus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(width: 24, height: 32)
                    }

                    Text("\(audio.bpm)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.amberAccent)
                        .frame(minWidth: 28)

                    Button(action: { audio.setBpm(audio.bpm + 2) }) {
                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(width: 24, height: 32)
                    }
                }
                .padding(.horizontal, 4)
                .background(AppTheme.surfaceDark)
                .cornerRadius(8)

                // Metronome Button
                Button(action: { audio.toggleMetronome() }) {
                    Image(systemName: audio.isMetronomeActive ? "metronome.fill" : "metronome")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(audio.isMetronomeActive ? AppTheme.amberAccent : AppTheme.textSecondary)
                        .frame(width: 36, height: 32)
                        .background(audio.isMetronomeActive ? AppTheme.amberAccent.opacity(0.15) : AppTheme.surfaceDark)
                        .cornerRadius(8)
                }

                // Quantize Indicator
                Button(action: { audio.isQuantizeEnabled.toggle() }) {
                    Text("1/16")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(audio.isQuantizeEnabled ? AppTheme.neonCyan : AppTheme.textSecondary)
                        .frame(width: 38, height: 32)
                        .background(audio.isQuantizeEnabled ? AppTheme.neonCyan.opacity(0.15) : AppTheme.surfaceDark)
                        .cornerRadius(8)
                }

                Spacer()

                // Stop All Sounds Button
                Button(action: { audio.stopAll() }) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 34, height: 32)
                        .background(AppTheme.surfaceDark)
                        .cornerRadius(8)
                }

                // REC Button
                Button(action: { audio.toggleRecording() }) {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(audio.isRecording ? AppTheme.padRecordingRed : AppTheme.textSecondary)
                            .frame(width: 8, height: 8)

                        if audio.isRecording {
                            Text(String(format: "%02d:%02d", Int(audio.recordingDuration) / 60, Int(audio.recordingDuration) % 60))
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.padRecordingRed)
                        } else {
                            Text("REC")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 32)
                    .background(audio.isRecording ? AppTheme.padRecordingRed.opacity(0.2) : AppTheme.surfaceDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(audio.isRecording ? AppTheme.padRecordingRed : Color.clear, lineWidth: 1)
                    )
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)

            // 4x3 Launchpad Grid
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<min(12, audio.currentPack.pads.count), id: \.self) { index in
                    NeonPadCell(
                        pad: audio.currentPack.pads[index],
                        index: index,
                        isSideB: audio.isSideB,
                        isPressed: audio.activePadSlots.contains(index),
                        isLooping: audio.activeLoopSlots.contains(index),
                        onTap: {
                            audio.playPad(index: index)
                        }
                    )
                }
            }
            .padding(.horizontal, 14)

            Spacer(minLength: 4)
        }
        .background(AppTheme.backgroundDark.edgesIgnoringSafeArea(.all))
    }
}

struct NeonPadCell: View {
    let pad: PadModel
    let index: Int
    let isSideB: Bool
    let isPressed: Bool
    let isLooping: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(pad.family.rawValue)
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundColor(pad.family.color)

                        Spacer()

                        if pad.mode == .loop {
                            Image(systemName: "infinity")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(isLooping ? AppTheme.neonCyan : AppTheme.textSecondary)
                        }
                    }

                    Spacer()

                    Text(pad.name)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(isSideB ? "Side B" : "Side A")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .frame(height: 98)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    pad.padColor.opacity(isPressed ? 0.75 : (isLooping ? 0.45 : 0.20)),
                                    AppTheme.surfaceDark
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isPressed ? Color.white : (isLooping ? AppTheme.neonCyan : pad.padColor),
                            lineWidth: isPressed ? 2.5 : (isLooping ? 2.0 : 1.2)
                        )
                )
                .shadow(
                    color: isPressed ? pad.padColor.opacity(0.8) : (isLooping ? AppTheme.neonCyan.opacity(0.5) : Color.clear),
                    radius: isPressed ? 12 : 6
                )
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
