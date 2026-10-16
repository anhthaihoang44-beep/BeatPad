import SwiftUI

struct SequencerView: View {
    @State private var isPlaying = false
    @State private var currentStep = 0
    @State private var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 16), count: 12)

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { isPlaying.toggle() }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                    Text("16-Step Grid Sequencer")
                        .font(.headline)
                    Spacer()
                }
                .padding()

                ScrollView([.horizontal, .vertical]) {
                    VStack(spacing: 6) {
                        ForEach(0..<12, id: \.self) { row in
                            HStack(spacing: 6) {
                                ForEach(0..<16, id: \.self) { col in
                                    Rectangle()
                                        .fill(grid[row][col] ? Color.orange : Color(white: 0.2))
                                        .frame(width: 32, height: 32)
                                        .cornerRadius(4)
                                        .onTapGesture {
                                            grid[row][col].toggle()
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Loop Editor")
        }
    }
}

struct LearnView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Neon Trap Lessons")) {
                    Text("Lesson 1: Kick & Snare Basics")
                    Text("Lesson 2: Hi-Hat Rolls")
                    Text("Lesson 3: Full Trap Drop")
                }
                Section(header: Text("Deep House Lessons")) {
                    Text("Lesson 1: Four on the Floor")
                    Text("Lesson 2: Offbeat Hats")
                    Text("Lesson 3: Bassline Groove")
                }
            }
            .navigationTitle("Learn Mode")
        }
    }
}
