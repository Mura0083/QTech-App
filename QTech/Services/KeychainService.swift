//
//  KeychainService.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import Foundation
import CryptoKit
import Security

enum KeychainError: Error {
    case invalidKeyData
    case unexpectedStatus(OSStatus)
}

struct KeychainService {
    private let service = "SecureMessenger.Encryption"
    private let account = "local-message-key"

    func loadOrCreateKey() throws -> SymmetricKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        
        if status == errSecSuccess {
            guard let keyData = result as? Data,
                  keyData.count == 32 else {
                throw KeychainError.invalidKeyData
            }

            return SymmetricKey(data: keyData)
        }

        guard status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
        let newKey = SymmetricKey(size: .bits256)
        let keyData = newKey.withUnsafeBytes {Data($0)}

        let saveQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let saveStatus = SecItemAdd(
            saveQuery as CFDictionary,
            nil
        )
        
        guard saveStatus == errSecSuccess else {
            throw KeychainError.unexpectedStatus(saveStatus)
        }

        return newKey
    }
}
