import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showingGuestMode = false
    @State private var pendingGuestMode = false
    @State private var showingGuestHome = false
    @State private var showLegalAgreement = false
    @State private var debugAuthLogging = UserDefaults.standard.bool(forKey: "debug.auth.logging")
    @State private var showingDebugMenu = false
    @State private var authManager = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                    .background {
                        StoryboardBackground(name: "login_background_light")
                            .ignoresSafeArea()
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .blur(radius: 0)
                            .ignoresSafeArea()
                    }
                    .scaledToFit()
                    .frame(height: 120)
                    .accessibilityLabel("AM Solutions - Hiring")
          
                HStack {
                    Text("Continue as Guest")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: 312) // approximately two 200pt buttons + 12pt spacing
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .cornerRadius(10)
            }
        }
    }
    
    
    
}
