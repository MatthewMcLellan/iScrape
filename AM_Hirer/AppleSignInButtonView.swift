import AuthenticationServices
import SwiftUI

struct AppleSignInButtonView: View {
    var requestedScopes: [ASAuthorization.Scope]
    var onCompletion: (Result<ASAuthorization, Error>) -> Void

    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = requestedScopes
            },
            onCompletion: { result in
                onCompletion(result)
            }
        )
        .signInWithAppleButtonStyle(.black)
        .frame(width: 280, height: 45)
    }
}
