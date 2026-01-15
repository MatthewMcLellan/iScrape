import SwiftUI

struct StoryboardBackground: View {
    let name: String

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .accessibilityHidden(true)
    }
}

#Preview {
    StoryboardBackground(name: "login_background")
}
