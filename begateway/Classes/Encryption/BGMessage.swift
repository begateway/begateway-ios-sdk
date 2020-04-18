//
//  BGMessage.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/2/19.
//

import Foundation

protocol BGMessage {
    var data: Data { get }
    var base64String: String { get }
    init(data: Data)
    init(base64Encoded base64String: String) throws
}

extension BGMessage {
    
    /// Base64-encoded string of the message data
    var base64String: String {
        return data.base64EncodedString()
    }
    
    /// Creates an encrypted message with a base64-encoded string.
    ///
    /// - Parameter base64String: Base64-encoded data of the encrypted message
    /// - Throws: BGRSAError
    init(base64Encoded base64String: String) throws {
        guard let data = Data(base64Encoded: base64String) else {
            throw BGRSAError.invalidBase64String
        }
        self.init(data: data)
    }
}
