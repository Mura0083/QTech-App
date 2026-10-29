//
//  Untitled.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import Foundation
import CryptoKit

enum EncryptionError : Error {
    case invalidData
}

struct EncryptionService {
    
    func encrypt(_ data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        
        guard let combined = sealedBox.combined else {
            throw EncryptionError.invalidData
        }
        return combined
    }
    
    func decrypt(_ encryptedData: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        
        return try AES.GCM.open(sealedBox, using: key)
    }
}
