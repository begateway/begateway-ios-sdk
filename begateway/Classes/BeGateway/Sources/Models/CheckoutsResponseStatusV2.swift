// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let checkoutsResponseStatusV2 = try? newJSONDecoder().decode(CheckoutsResponseStatusV2.self, from: jsonData)

import Foundation

// MARK: - CheckoutsResponseStatusV2
struct CheckoutsResponseStatusV2: Codable {
    let checkout: CheckoutsResponseStatusV2Checkout?
}

// MARK: - Checkout
struct CheckoutsResponseStatusV2Checkout: Codable {
    let token: String?
    let shopID: Int?
    let transactionType: String?
//    let order: CheckoutsResponseStatusV2Order?
    let finished, expired, test: Bool?
    let status: String?
    let version, appleMerchantID: String?
    
    enum CodingKeys: String, CodingKey {
        case token
        case shopID = "shop_id"
        case transactionType = "transaction_type"
//        case order, finished, expired, test, status, message, version
        case finished, expired, test, status, version
        case appleMerchantID = "apple_merchant_id"
    }
}

// MARK: - Order
struct CheckoutsResponseStatusV2Order: Codable {
    let currency: String?
    let amount: Int?
    let orderDescription, trackingID: String?
    let additionalData: CheckoutsResponseStatusV2AdditionalData?
    let expiredAt: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case currency, amount
        case orderDescription = "description"
        case trackingID = "tracking_id"
        case additionalData = "additional_data"
        case expiredAt = "expired_at"
    }
}

// MARK: - AdditionalData
struct CheckoutsResponseStatusV2AdditionalData: Codable {
    let contract: [String]?
    let requestID: String?
    let browser: JSONNull?
    let vendor: CheckoutsResponseStatusV2Vendor?
    
    enum CodingKeys: String, CodingKey {
        case contract
        case requestID = "request_id"
        case browser, vendor
    }
}

// MARK: - Vendor
struct CheckoutsResponseStatusV2Vendor: Codable {
    let name, token: String?
}
