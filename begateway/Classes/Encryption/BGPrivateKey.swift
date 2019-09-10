//
//  BGPrivateKey.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/2/19.
//

import Foundation

class BGPrivateKey: BGKey {
    
    /// Reference to the key within the keychain
    let reference: SecKey
    
    /// Original data of the private key.
    /// Note that it does not contain PEM headers and holds data as bytes, not as a base 64 string.
    let originalData: Data?
    
    let tag: String?
    
    /// Returns a PEM representation of the private key.
    ///
    /// - Returns: Data of the key, PEM-encoded
    /// - Throws: SwiftyRSAError
    func pemString() throws -> String {
        let data = try self.data()
        let pem = BGRSA.format(keyData: data, withPemType: "RSA PRIVATE KEY")
        return pem
    }
    
    /// Creates a private key with a keychain key reference.
    /// This initializer will throw if the provided key reference is not a private RSA key.
    ///
    /// - Parameter reference: Reference to the key within the keychain.
    /// - Throws: SwiftyRSAError
    required init(reference: SecKey) throws {
        
        guard BGRSA.isValidKeyReference(reference, forClass: kSecAttrKeyClassPrivate) else {
            throw BGRSAError.notAPrivateKey
        }
        
        self.reference = reference
        self.tag = nil
        self.originalData = nil
    }
    
    /// Creates a private key with a RSA public key data.
    ///
    /// - Parameter data: Private key data
    /// - Throws: SwiftyRSAError
    required init(data: Data) throws {
        self.originalData = data
        let tag = UUID().uuidString
        self.tag = tag
        let dataWithoutHeader = try BGRSA.stripKeyHeader(keyData: data)
        reference = try BGRSA.addKey(dataWithoutHeader, isPublic: false, tag: tag)
    }
    
    deinit {
        if let tag = tag {
            BGRSA.removeKey(tag: tag)
        }
    }
}
