//
//  BGEncyption.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/7/19.
//

import Foundation

public class BGEncryption {
    static public func encrypt(message: String, with pemEncodedPublicKey: String) -> (message: String?, error: Error?) {
        do {
            let key = try BGPublicKey(pemEncoded: pemEncodedPublicKey)
            
            let clear = try BGClearMessage(base64Encoded: Data(message.utf8).base64EncodedString())
            let encrypted = try clear.encrypted(with: key, padding: .PKCS1)
            
            let base64String = encrypted.base64String
            return (base64String, nil)
        } catch let error {
            return (nil, error)
        }
    }
}
