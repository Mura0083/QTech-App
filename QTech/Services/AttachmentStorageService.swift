//
//  AttachmentStorageService.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import Foundation

enum AttachmentError: LocalizedError {
    case invalidImage
    case invalidFilename

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Unable to load the selected image."
        case .invalidFilename:
            return "Invalid attachment filename."
        }
    }
}

struct AttachmentStorageService {
    
    private let directory = URL.applicationSupportDirectory
        .appendingPathComponent(
            "EncryptedAttachments",
            isDirectory: true
        )
    
    func save(_ encryptedData: Data) throws -> String {
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        let filename = UUID().uuidString + ".enc"
        let fileURL = directory.appendingPathComponent(filename)

        try encryptedData.write(
            to: fileURL,
            options: [.atomic, .completeFileProtection]
        )

        return filename
    }
    
    func load(filename: String) throws -> Data {
        let fileURL = try validatedURL(for: filename)
        return try Data(contentsOf: fileURL)
    }
    
    func delete(filename: String) throws {
        let fileURL = try validatedURL(for: filename)
        try FileManager.default.removeItem(at: fileURL)
    }
    
    private func validatedURL(for filename: String) throws -> URL {
        guard filename == URL(fileURLWithPath: filename).lastPathComponent,
              filename.hasSuffix(".enc") else {
            throw AttachmentError.invalidFilename
        }

        return directory.appendingPathComponent(filename)
    }
}
