// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let requestPaymentAppleV2 = try? newJSONDecoder().decode(RequestPaymentAppleV2.self, from: jsonData)

import Foundation

// MARK: - RequestPaymentAppleV2
struct RequestPaymentAppleV2: Codable {
    let request: RequestPaymentAppleV2Request
    let token: String
    let contract: Bool

    enum CodingKeys: String, CodingKey {
        case request, token, contract
    }
}

// MARK: - Request
struct RequestPaymentAppleV2Request: Codable {
    let token: AppleTokenRequestV2
}

// MARK: - Token
struct AppleTokenRequestV2: Codable {
    let paymentData: PaymentData
    let paymentMethod: PaymentMethod
    let transactionIdentifier: String
}

// MARK: - PaymentData
struct PaymentData: Codable {
    let version, data, signature: String
    let header: Header
}

// MARK: - Header
struct Header: Codable {
    let ephemeralPublicKey, publicKeyHash, transactionID: String

    enum CodingKeys: String, CodingKey {
        case ephemeralPublicKey, publicKeyHash
        case transactionID = "transactionId"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let displayName, network, type: String
}
