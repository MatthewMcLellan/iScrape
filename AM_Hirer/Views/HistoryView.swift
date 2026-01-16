import SwiftUI
import Combine

struct HistoryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                emptyStateView
            }
            .background {
                // Use existing background helper with known assets
                StoryboardBackground(name: colorScheme == .dark ? "login_background" : "login_background_light")
                    .ignoresSafeArea()
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText, prompt: "Search")
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            
            Text("No History Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your saved items will appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
