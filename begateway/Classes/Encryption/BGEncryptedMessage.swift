//
//  BGEncryptedMessage.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/2/19.
//

import Foundation

class BGEncryptedMessage: BGMessage {
    
    /// Data of the message
    let data: Data
    
    /// Creates an encrypted message with data.
    ///
    /// - Parameter data: Data of the encrypted message.
    required init(data: Data) {
        self.data = data
    }
    
    /// Decrypts an encrypted message with a private key and returns a clear message.
    ///
    /// - Parameters:
    ///   - key: Private key to decrypt the mssage with
    ///   - padding: Padding to use during the decryption
    /// - Returns: Clear message
    /// - Throws: BGRSAError
    func decrypted(with key: BGPrivateKey, padding: BGPadding) throws -> BGClearMessage {
        let blockSize = SecKeyGetBlockSize(key.reference)
        
        var encryptedDataAsArray = [UInt8](repeating: 0, count: data.count)
        (data as NSData).getBytes(&encryptedDataAsArray, length: data.count)
        
        var decryptedDataBytes = [UInt8](repeating: 0, count: 0)
        var idx = 0
        while idx < encryptedDataAsArray.count {
            
            let idxEnd = min(idx + blockSize, encryptedDataAsArray.count)
            let chunkData = [UInt8](encryptedDataAsArray[idx..<idxEnd])
            
            var decryptedDataBuffer = [UInt8](repeating: 0, count: blockSize)
            var decryptedDataLength = blockSize
            
            let status = SecKeyDecrypt(key.reference, padding, chunkData, idxEnd-idx, &decryptedDataBuffer, &decryptedDataLength)
            guard status == noErr else {
                throw BGRSAError.chunkDecryptFailed(index: idx)
            }
            
            decryptedDataBytes += [UInt8](decryptedDataBuffer[0..<decryptedDataLength])
            
            idx += blockSize
        }
        
        if let bytes = decryptedDataBytes.withUnsafeBufferPointer({ $0 }).baseAddress {
            let decryptedData = Data(bytes: UnsafePointer<UInt8>(bytes), count: decryptedDataBytes.count)
            return BGClearMessage(data: decryptedData)
        } else {
            throw BGRSAError.chunkDecryptFailed(index: idx)
        }
    }
}
