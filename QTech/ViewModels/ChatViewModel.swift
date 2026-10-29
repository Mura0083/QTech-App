//
//  CharViewModel.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import Foundation
import SwiftData
import CryptoKit
import UIKit

@MainActor
final class ChatViewModel {
    
    private let encryptionService = EncryptionService()
    private let keychainService = KeychainService()
    private let attachmentStorage = AttachmentStorageService()
    
    private var cachedKey: SymmetricKey?
    
    private func loadKey() throws -> SymmetricKey {
        if let cachedKey {
            return cachedKey
        }
        
        let key = try keychainService.loadOrCreateKey()
        cachedKey = key
        return key
    }
    
    func sendText(_ rawText: String, context: ModelContext) throws {
        let text = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !text.isEmpty else {
            return
        }
        
        let key = try loadKey()
        
        let encryptedData = try encryptionService.encrypt(
            Data(text.utf8),
            using: key
        )
        
        let message = MessageItem(
            encryptedText: encryptedData,
            isOutgoing: true
        )
        
        context.insert(message)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    func decryptedText(for message: MessageItem) -> String? {
        guard let encryptedData = message.encryptedText else {
            return nil
        }
        
        do {
            let decryptedData = try encryptionService.decrypt(
                encryptedData,
                using: loadKey()
            )

            return String(data: decryptedData, encoding: .utf8)
                ?? "Invalid message encoding"
        } catch {
            return "Unable to decrypt message"
        }

    }
    
    func sendImage(_ imageData: Data, context: ModelContext) throws {
        let key = try loadKey()
        
        let encryptedData = try encryptionService.encrypt(
            imageData,
            using: key
        )
        
        let filename = try attachmentStorage.save(encryptedData)
        
        let message = MessageItem(
            isOutgoing: true,
            attachmentPath: filename,
            attachmentName: "Photo",
            attachmentType: "image/jpeg"
        )
        
        context.insert(message)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            try? attachmentStorage.delete(filename: filename)
            throw error
        }
    }
    
    func decryptedImage(for message: MessageItem) -> UIImage? {
        guard let filename = message.attachmentPath else {
            return nil
        }
        
        do {
            let encryptedData = try attachmentStorage.load(
                filename: filename
            )

            let decryptedData = try encryptionService.decrypt(
                encryptedData,
                using: loadKey()
            )

            return UIImage(data: decryptedData)
        } catch {
            return nil
        }
    }
}
