//
//  BGCard.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/8/19.
//

import Foundation
import UIKit

public struct BGCard: Codable, Equatable {
    public var number: String
    public var verificationValue: String
    public var holder: String
    public var expMonth: String
    public var expYear: String
    
    public static func ecnrypted(_ card: BGCard, with publicKey: String) -> (card: BGCard?, error: Error?) {
        let eNumber = BGEncryption.encrypt(message: card.number, with: publicKey)
        let eVerificationValue = BGEncryption.encrypt(message: card.verificationValue, with: publicKey)
        let eHolder = BGEncryption.encrypt(message: card.holder, with: publicKey)
        let eExpMonth = BGEncryption.encrypt(message: card.expMonth, with: publicKey)
        let eExpYear = BGEncryption.encrypt(message: card.expYear, with: publicKey)
        
        if let error = eNumber.error ?? eVerificationValue.error ?? eHolder.error ?? eExpMonth.error ?? eExpYear.error {
            return (nil, error)
        }
        if let num = eNumber.message, let ver = eVerificationValue.message,
            let hol = eHolder.message, let mon = eExpMonth.message, let year = eExpYear.message {
            return (BGCard(number: num, verificationValue: ver, holder: hol, expMonth: mon, expYear: year), nil)
        }
        
        return (nil, nil)
    }
    
    var description: String {
        return "number: \(number), cvv: \(verificationValue), holder: \(holder), date: \(expMonth)\\\(expYear)"
    }
    
    public init(number: String,
                verificationValue: String,
                holder: String,
                expMonth: String,
                expYear: String) {
        self.number = number
        self.holder = holder
        self.verificationValue = verificationValue
        self.expMonth = expMonth
        self.expYear = expYear
    }
    
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case verificationValue = "verification_value"
        case holder = "holder"
        case expMonth = "exp_month"
        case expYear = "exp_year"
    }
}
