//
//  Models.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import Foundation
import SwiftData

@Model
final class MessageItem {
    var id: UUID
    var encryptedText: Data?
    var createdAt: Date
    var isOutgoing: Bool
    var attachmentPath: String?
    var attachmentName: String?
    var attachmentType: String?
    
    init(
        id: UUID = UUID(),
        encryptedText: Data? = nil,
        createdAt: Date = .now,
        isOutgoing: Bool = false,
        attachmentPath: String? = nil,
        attachmentName: String? = nil,
        attachmentType: String? = nil
    ) {
        self.id = id
        self.encryptedText = encryptedText
        self.createdAt = createdAt
        self.isOutgoing = isOutgoing
        self.attachmentPath = attachmentPath
        self.attachmentName = attachmentName
        self.attachmentType = attachmentType
    }
}
