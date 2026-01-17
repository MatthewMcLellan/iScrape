//
//  ContentView.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 12/17/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fallbackAuthManager = HirerAuthenticationManager()
    @EnvironmentObject private var authManager: HirerAuthenticationManager

    var body: some View {
        // TEMP: Bypass authentication checks to unblock development
        // Ensure an auth manager is always available in the environment
        Group {
            TabBar()
        }
        // Note: We inject both the environment-provided manager and a local fallback.
        // SwiftUI uses the nearest matching type; if an ancestor provided one, it wins.
        .environmentObject(fallbackAuthManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a concrete environment object for preview to avoid runtime crashes
        Group {
            ContentView()
                .environmentObject(HirerAuthenticationManager.preview)
                .previewDisplayName("Logged Out")

            ContentView()
                .environmentObject(HirerAuthenticationManager.previewAuthenticated)
                .previewDisplayName("Logged In")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HirerAuthenticationManager.preview)
}

