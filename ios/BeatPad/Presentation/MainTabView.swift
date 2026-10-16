import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LaunchpadView()
                .tabItem {
                    Label("Play", systemImage: "play.circle.fill")
                }
                .tag(0)

            SequencerView()
                .tabItem {
                    Label("Loop", systemImage: "repeat.circle.fill")
                }
                .tag(1)

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "graduationcap.fill")
                }
                .tag(2)

            TracksView()
                .tabItem {
                    Label("Tracks", systemImage: "music.note.list")
                }
                .tag(3)
        }
        .accentColor(.orange)
    }
}

struct TracksView: View {
    var body: some View {
        NavigationView {
            Text("No recorded tracks yet")
                .foregroundColor(.gray)
                .navigationTitle("My Tracks")
        }
    }
}
