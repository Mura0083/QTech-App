//
//  TestView.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import SwiftUI
import CryptoKit

struct TestView: View {
    var body: some View {
        Text("Testing Keychain")
            .task {
                testKeychain()
            }
    }
    
    private func testKeychain() {
        let keychain = KeychainService()
        let encryption = EncryptionService()

        do {
            let firstKey = try keychain.loadOrCreateKey()
            let secondKey = try keychain.loadOrCreateKey()

            let originalData = Data("Hello Keychain!".utf8)

            let encrypted = try encryption.encrypt(
                originalData,
                using: firstKey
            )

            let decrypted = try encryption.decrypt(
                encrypted,
                using: secondKey
            )

            let message = String(data: decrypted, encoding: .utf8)

            print("Keychain test:", message == "Hello Keychain!")

        } catch {
            print("Keychain error:", error)
        }
    }
}
