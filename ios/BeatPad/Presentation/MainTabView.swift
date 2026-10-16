import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1

    init() {
        // Configure dark translucent tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 21/255.0, green: 23/255.0, blue: 28/255.0, alpha: 1.0)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: ) {
            PacksLibraryView(selectedTab: )
                .tabItem {
                    Label("Packs", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            LaunchpadView(selectedTab: )
                .tabItem {
                    Label("Play", systemImage: "circle.grid.3x3.fill")
                }
                .tag(1)

            SequencerView()
                .tabItem {
                    Label("Loop", systemImage: "repeat.circle.fill")
                }
                .tag(2)

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "graduationcap.fill")
                }
                .tag(3)

            TracksView()
                .tabItem {
                    Label("Tracks", systemImage: "music.note.list")
                }
                .tag(4)
        }
        .accentColor(AppTheme.amberAccent)
    }
}
