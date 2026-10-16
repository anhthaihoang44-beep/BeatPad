import SwiftUI

struct LearnView: View {
    @ObservedObject var audio = AudioEngine.shared
    @State private var activeLesson: LessonModel?
    @State private var isPlayingArena = false
    @State private var currentStepIndex = 0
    @State private var score = 0
    @State private var combo = 0
    @State private var feedbackText = ""
    @State private var feedbackColor = Color.clear
    @State private var showScoreModal = false
    @State private var arenaTimer: Timer?

    let lessons: [LessonModel] = [
        LessonModel(
            id: "trap_1",
            title: "Trap 101: Kick & Snare",
            genre: "Trap",
            bpm: 140,
            difficulty: "Beginner",
            description: "Learn the foundational rhythm of modern trap music: Kick on beat 1, Snare on beat 3.",
            steps: [
                LessonStep(step: 0, padIndex: 0, beatTime: 1.0),
                LessonStep(step: 1, padIndex: 1, beatTime: 2.0),
                LessonStep(step: 2, padIndex: 0, beatTime: 3.0),
                LessonStep(step: 3, padIndex: 1, beatTime: 4.0),
                LessonStep(step: 4, padIndex: 0, beatTime: 5.0),
                LessonStep(step: 5, padIndex: 1, beatTime: 6.0),
                LessonStep(step: 6, padIndex: 0, beatTime: 7.0),
                LessonStep(step: 7, padIndex: 1, beatTime: 8.0)
            ]
        ),
        LessonModel(
            id: "trap_2",
            title: "Hi-Hat Rolls & Clap Groove",
            genre: "Trap",
            bpm: 140,
            difficulty: "Intermediate",
            description: "Layer rapid hi-hat rolls between kicks and claps for high-energy rhythm.",
            steps: [
                LessonStep(step: 0, padIndex: 2, beatTime: 1.0),
                LessonStep(step: 1, padIndex: 2, beatTime: 1.5),
                LessonStep(step: 2, padIndex: 5, beatTime: 2.0),
                LessonStep(step: 3, padIndex: 2, beatTime: 2.5),
                LessonStep(step: 4, padIndex: 0, beatTime: 3.0),
                LessonStep(step: 5, padIndex: 5, beatTime: 4.0)
            ]
        ),
        LessonModel(
            id: "house_1",
            title: "Four-on-the-Floor House",
            genre: "House",
            bpm: 124,
            difficulty: "Beginner",
            description: "The classic heartbeat of dance music: solid kick on every beat with offbeat hats.",
            steps: [
                LessonStep(step: 0, padIndex: 0, beatTime: 1.0),
                LessonStep(step: 1, padIndex: 2, beatTime: 1.5),
                LessonStep(step: 2, padIndex: 0, beatTime: 2.0),
                LessonStep(step: 3, padIndex: 2, beatTime: 2.5),
                LessonStep(step: 4, padIndex: 0, beatTime: 3.0),
                LessonStep(step: 5, padIndex: 2, beatTime: 3.5),
                LessonStep(step: 6, padIndex: 0, beatTime: 4.0),
                LessonStep(step: 7, padIndex: 2, beatTime: 4.5)
            ]
        )
    ]

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundDark.edgesIgnoringSafeArea(.all)

                if isPlayingArena, let lesson = activeLesson {
                    // Arena Game Screen
                    VStack(spacing: 20) {
                        // Score Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text("SCORE")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("\(score)")
                                    .font(.system(size: 26, weight: .black))
                                    .foregroundColor(AppTheme.amberAccent)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("COMBO")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("x\(combo)")
                                    .font(.system(size: 26, weight: .black))
                                    .foregroundColor(AppTheme.neonCyan)
                            }
                        }
                        .padding(.horizontal, 24)

                        // Feedback Banner
                        Text(feedbackText)
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(feedbackColor)
                            .frame(height: 36)

                        // Target Prompt
                        let targetPad = (currentStepIndex < lesson.steps.count) ? lesson.steps[currentStepIndex].padIndex : 0
                        let padName = (targetPad < audio.currentPack.pads.count) ? audio.currentPack.pads[targetPad].name : "Pad \(targetPad + 1)"

                        VStack(spacing: 8) {
                            Text("TAP NOW")
                                .font(.system(size: 12, weight: .heavy))
                                .foregroundColor(AppTheme.neonPink)

                            Text(padName)
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppTheme.surfaceElevatedDark)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(AppTheme.neonPink, lineWidth: 2)
                                        )
                                )
                                .shadow(color: AppTheme.neonPink.opacity(0.6), radius: 10)
                        }

                        // Pad Grid to play
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(0..<min(6, audio.currentPack.pads.count), id: \.self) { idx in
                                Button(action: {
                                    handlePadTapInArena(tappedIndex: idx, targetIndex: targetPad, lesson: lesson)
                                }) {
                                    VStack {
                                        Text(audio.currentPack.pads[idx].name)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 70)
                                    .background(idx == targetPad ? AppTheme.neonPink.opacity(0.4) : AppTheme.surfaceDark)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(idx == targetPad ? AppTheme.neonPink : AppTheme.borderDark, lineWidth: idx == targetPad ? 2 : 1)
                                    )
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer()

                        // Exit button
                        Button(action: { stopArena() }) {
                            Text("QUIT LESSON")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary)
                                .padding()
                        }
                    }
                    .padding(.top, 16)

                } else {
                    // Lessons List Screen
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(lessons) { lesson in
                                LessonCardView(lesson: lesson) {
                                    startArena(lesson: lesson)
                                }
                            }
                        }
                        .padding(16)
                    }
                    .navigationTitle("Learn Mode")
                }
            }
            .alert(isPresented: $showScoreModal) {
                Alert(
                    title: Text("Lesson Complete!"),
                    message: Text("Awesome rhythm skills!\nFinal Score: \(score)\nAccuracy: 95% - 3 Stars!"),
                    dismissButton: .default(Text("Done"), action: { stopArena() })
                )
            }
        }
    }

    private func startArena(lesson: LessonModel) {
        activeLesson = lesson
        isPlayingArena = true
        currentStepIndex = 0
        score = 0
        combo = 0
        feedbackText = "GET READY!"
        feedbackColor = AppTheme.neonCyan
    }

    private func handlePadTapInArena(tappedIndex: Int, targetIndex: Int, lesson: LessonModel) {
        audio.playPad(index: tappedIndex)

        if tappedIndex == targetIndex {
            score += 100 + (combo * 10)
            combo += 1
            feedbackText = "PERFECT!"
            feedbackColor = AppTheme.neonGreen

            currentStepIndex += 1
            if currentStepIndex >= lesson.steps.count {
                showScoreModal = true
            }
        } else {
            combo = 0
            feedbackText = "MISS!"
            feedbackColor = AppTheme.padRecordingRed
        }
    }

    private func stopArena() {
        isPlayingArena = false
        activeLesson = nil
        arenaTimer?.invalidate()
        arenaTimer = nil
    }
}

struct LessonCardView: View {
    let lesson: LessonModel
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(lesson.title)
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.white)
                Spacer()
                Text(lesson.difficulty)
                    .font(.system(size: 11, weight: .heavy))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(AppTheme.amberAccent.opacity(0.2))
                    .foregroundColor(AppTheme.amberAccent)
                    .cornerRadius(6)
            }

            Text(lesson.description)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)

            HStack {
                Label("\(lesson.bpm) BPM", systemImage: "metronome")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)

                Spacer()

                Button(action: onStart) {
                    HStack(spacing: 6) {
                        Image(systemName: "play.circle.fill")
                        Text("START PRACTICE")
                    }
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundColor(AppTheme.backgroundDark)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(AppTheme.neonPink)
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.surfaceDark)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.borderDark, lineWidth: 1)
        )
    }
}