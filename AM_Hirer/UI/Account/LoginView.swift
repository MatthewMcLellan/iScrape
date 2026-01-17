import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @EnvironmentObject var auth: HirerAuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
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
                Image("Default")
                    .resizable()
                    .frame(width: 220)
                    .scaledToFit()
                    .frame(height: 220)
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
                
                AppleSignInButtonView(requestedScopes: [.fullName, .email]) { result in
                    switch result {
                    case .success(let res):
                        // TODO: Wire this up to HIRE-R's auth layer
                        if let appleIDCredential = (res.credential as? ASAuthorizationAppleIDCredential) {
                            if let tokenData = appleIDCredential.identityToken,
                               let tokenString = String(data: tokenData, encoding: .utf8) {
                                print("[HIRE-R] Apple identity token length: \(tokenString.count)")
                            } else {
                                print("[HIRE-R] Apple identity token not available or could not be decoded")
                            }
                            if let email = appleIDCredential.email {
                                print("[HIRE-R] Apple provided email: \(email)")
                            }
                            UserDefaults.standard.set(true, forKey: "auth.loggedIn")
                            dismiss()
                        } else {
                            print("[HIRE-R] Unexpected credential type")
                            UserDefaults.standard.set(true, forKey: "auth.loggedIn")
                            dismiss()
                        }
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        UserDefaults.standard.set(true, forKey: "auth.loggedIn")
                        dismiss()
                    }
                }
            }
        }
    }
    
    
    
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(HirerAuthenticationManager())
    }
}

