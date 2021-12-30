// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responsePaymentV2 = try? newJSONDecoder().decode(ResponsePaymentV2.self, from: jsonData)

import Foundation

// MARK: - ResponsePaymentV2
struct ResponsePaymentV2: Codable {
    let response: ResponsePaymentV2Response?
}

// MARK: - Response
struct ResponsePaymentV2Response: Codable {
    let message: String?
    let errors: JSONNull?
    let status, token, transactionType, uid: String?
    let url: String?
    let iframe: Bool?
    let authCode, bankCode, rrn, billingDescriptor: String?
    let creditCard: ResponsePaymentV2CreditCard?
    let receiptURL: String?
    let gatewayID: Int?
    let actionStatus, method: String?
    let finished: Bool?
    
    enum CodingKeys: String, CodingKey {
        case message, errors, status, token
        case transactionType = "transaction_type"
        case uid, url, iframe
        case authCode = "auth_code"
        case bankCode = "bank_code"
        case rrn
        case billingDescriptor = "billing_descriptor"
        case creditCard = "credit_card"
        case receiptURL = "receipt_url"
        case gatewayID = "gateway_id"
        case actionStatus = "action_status"
        case method, finished
    }
}

// MARK: - CreditCard
struct ResponsePaymentV2CreditCard: Codable {
    let holder, stamp, brand, last4: String?
    let first1, bin, issuerCountry, issuerName: String?
    let product: String?
    let expMonth, expYear: Int?
//    let tokenProvider: Any?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case holder, stamp, brand
        case last4 = "last_4"
        case first1 = "first_1"
        case bin
        case issuerCountry = "issuer_country"
        case issuerName = "issuer_name"
        case product
        case expMonth = "exp_month"
        case expYear = "exp_year"
//        case tokenProvider = "token_provider"
        case token
    }
}
