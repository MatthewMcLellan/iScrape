//
//  HirerAuthenticationManager.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//

internal import Foundation
import SwiftUI
import Security
import Combine

// Set this to true to bypass authentication entirely in Debug builds
#if DEBUG
private let BYPASS_AUTH = true
#else
private let BYPASS_AUTH = false
#endif

/// Authentication manager with optional Debug bypass to keep the app always signed in during development.
@MainActor
final class HirerAuthenticationManager: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = BYPASS_AUTH ? true : false
    @Published var userEmail: String? = nil

    private let keychain = KeychainHelper()
    private let keychainService = "com.hirer.auth"
    private let tokenAccount = "hirer.apple.identityToken"

    enum AuthError: LocalizedError {
        case invalidToken

        var errorDescription: String? {
            switch self {
            case .invalidToken:
                return "Invalid Apple identity token."
            }
        }
    }

    func signInWithApple(identityToken: String, email: String?) async throws {
        if BYPASS_AUTH {
            // Bypass: immediately mark as authenticated without touching keychain
            self.userEmail = email ?? self.userEmail
            self.isAuthenticated = true
            return
        }
        guard !identityToken.isEmpty else { throw AuthError.invalidToken }
        isLoading = true
        defer { isLoading = false }

        // TODO: Replace with your backend API call to validate the token and create a session.
        // For now, we persist the token locally and mark the user as authenticated.
        try keychain.save(identityToken, service: keychainService, account: tokenAccount)
        self.userEmail = email
        self.isAuthenticated = true
    }

    func signOut() {
        if BYPASS_AUTH {
            // Bypass: remain authenticated; clear only preview email
            // Comment the next line if you want to keep the preview email too
            // self.userEmail = nil
            self.isAuthenticated = true
            return
        }
        try? keychain.delete(service: keychainService, account: tokenAccount)
        self.userEmail = nil
        self.isAuthenticated = false
    }

    func storedToken() -> String? {
        if BYPASS_AUTH { return nil }
        return try? keychain.read(service: keychainService, account: tokenAccount)
    }
}

struct KeychainHelper {
    func save(_ value: String, service: String, account: String) throws {
        let data = Data(value.utf8)
        // Remove any existing item first
        _ = try? delete(service: service, account: account)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        // If you enable Keychain Sharing and want to share between apps, also set the access group:
        // query[kSecAttrAccessGroup as String] = "YOUR_KEYCHAIN_ACCESS_GROUP"

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandled(status: status) }
    }

    func read(service: String, account: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = item as? Data else {
            throw KeychainError.unhandled(status: status)
        }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    func delete(service: String, account: String) throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        switch status {
        case errSecSuccess, errSecItemNotFound:
            return true
        default:
            throw KeychainError.unhandled(status: status)
        }
    }

    enum KeychainError: LocalizedError {
        case unhandled(status: OSStatus)

        var errorDescription: String? {
            switch self {
            case .unhandled(let status):
                return "Keychain error with status: \(status)"
            }
        }
    }
}

#if DEBUG
extension HirerAuthenticationManager {
    /// A convenient preview instance for SwiftUI previews (unauthenticated by default)
    static var preview: HirerAuthenticationManager {
        let manager = HirerAuthenticationManager()
        manager.isAuthenticated = false
        manager.userEmail = nil
        return manager
    }
    /// A convenient authenticated preview instance
    static var previewAuthenticated: HirerAuthenticationManager {
        let manager = HirerAuthenticationManager()
        manager.isAuthenticated = true
        manager.userEmail = "preview@example.com"
        return manager
    }
}
#endif 

