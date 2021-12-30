// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let requestPaymentV2 = try? newJSONDecoder().decode(RequestPaymentV2.self, from: jsonData)

import Foundation

// MARK: - RequestPaymentV2
struct RequestPaymentV2: Codable {
    let request: RequestPaymentV2Request?
}

// MARK: - Request
struct RequestPaymentV2Request: Codable {
    let creditCard: RequestPaymentV2CreditCard?
    let paymentMethod, token: String?
    
    enum CodingKeys: String, CodingKey {
        case creditCard = "credit_card"
        case paymentMethod = "payment_method"
        case token
    }
}

// MARK: - CreditCard
struct RequestPaymentV2CreditCard: Codable {
    let number, verificationValue, expMonth, expYear: String?
    let holder: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case number
        case verificationValue = "verification_value"
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case holder
        case token
    }
    
    public static func ecnrypted(_ card: RequestPaymentV2CreditCard, with publicKey: String) -> (card: RequestPaymentV2CreditCard?, error: Error?) {
        let eNumber = BGEncryption.encrypt(message: card.number ?? "", with: publicKey)
        let eVerificationValue = BGEncryption.encrypt(message: card.verificationValue ?? "", with: publicKey)
        let eHolder = BGEncryption.encrypt(message: card.holder ?? "", with: publicKey)
        let eExpMonth = BGEncryption.encrypt(message: card.expMonth ?? "", with: publicKey)
        let eExpYear = BGEncryption.encrypt(message: card.expYear ?? "", with: publicKey)
        
        
        if let error = eNumber.error ?? eVerificationValue.error ?? eHolder.error ?? eExpMonth.error ?? eExpYear.error {
            return (nil, error)
        }
        
        if let num = eNumber.message, let ver = eVerificationValue.message,
           let hol = eHolder.message, let mon = eExpMonth.message, let year = eExpYear.message {
            return (RequestPaymentV2CreditCard(number: num, verificationValue: ver, expMonth: mon, expYear: year, holder: hol, token: nil), nil)
        }
        
        return (nil, nil)
    }
}
