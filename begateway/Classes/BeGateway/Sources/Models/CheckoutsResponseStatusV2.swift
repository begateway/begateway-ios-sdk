// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let checkoutsResponseStatusV2 = try? newJSONDecoder().decode(CheckoutsResponseStatusV2.self, from: jsonData)

import Foundation

// MARK: - CheckoutsResponseStatusV2
public struct CheckoutsResponseStatusV2: Codable {
    let checkout: CheckoutsResponseStatusV2Checkout?
}

// MARK: - Checkout
struct CheckoutsResponseStatusV2Checkout: Codable {
    let token: String?
    let shopID: Int?
    let transactionType: String?
    let order: CheckoutsResponseStatusV2Order?
    let finished, expired, test: Bool?
    let status: String?
    let version, appleMerchantID: String?
    let settings: CheckoutsResponceV2Settings?
    
    enum CodingKeys: String, CodingKey {
        case token
        case shopID = "shop_id"
        case transactionType = "transaction_type"
        case order
//        case order, finished, expired, test, status, message, version
        case finished, expired, test, status, version
        case appleMerchantID = "apple_merchant_id"
        case settings
    }
}

struct CheckoutsResponceV2Settings: Codable {
    let saveCardToggle: CheckoutsResponceV2SettingSaveCardToggle?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case saveCardToggle = "save_card_toggle"
        case language
    }
}
struct CheckoutsResponceV2SettingSaveCardToggle : Codable {
    let customerContract: Bool
    
    enum CodingKeys: String, CodingKey {
        case customerContract = "customer_contract"
    }
}

// MARK: - Order
struct CheckoutsResponseStatusV2Order: Codable {
    let additionalData: CheckoutsRequestV2AdditionalData?
    let amount: Int?
    let currency, orderDescription, trackingID: String?
    
    enum CodingKeys: String, CodingKey {
        case additionalData = "additional_data"
        case amount, currency
        case orderDescription = "description"
        case trackingID = "tracking_id"
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
