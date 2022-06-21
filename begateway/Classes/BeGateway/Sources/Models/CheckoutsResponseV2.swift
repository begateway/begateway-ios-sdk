// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let checkoutsResponseV2 = try? newJSONDecoder().decode(CheckoutsResponseV2.self, from: jsonData)

import Foundation

// MARK: - CheckoutsResponseV2
public struct CheckoutsResponseV2: Codable {
    public let checkout: CheckoutsResponseV2Checkout?
}

// MARK: - Checkout
public struct CheckoutsResponseV2Checkout: Codable {
    public let token: String?
    let redirectURL: String?
    let brands: [CheckoutsResponseV2Brand]?
    let company: CheckoutsResponseV2Company?
    let checkoutDescription: String?
    let cardInfo: CheckoutsResponseV2CardInfo?
    let googlePay: CheckoutsResponseV2GooglePay?
    let samsungPay: CheckoutsResponseV2SamsungPay?
    let async: Bool?
    
    enum CodingKeys: String, CodingKey {
        case token
        case redirectURL = "redirect_url"
        case brands, company
        case checkoutDescription = "description"
        case cardInfo = "card_info"
        case googlePay = "google_pay"
        case samsungPay = "samsung_pay"
        case async
    }
}

// MARK: - Brand
struct CheckoutsResponseV2Brand: Codable {
    let alternative: Bool?
    let name: String?
//    let requiredFields: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case alternative, name
//        case requiredFields = "required_fields"
    }
}

// MARK: - CardInfo
struct CheckoutsResponseV2CardInfo: Codable {
//    let creditCards: Any?
    let uuid: String?
    
    enum CodingKeys: String, CodingKey {
//        case creditCards = "credit_cards"
        case uuid
    }
}

// MARK: - Company
struct CheckoutsResponseV2Company: Codable {
    let name: String?
    let site: String?
}

// MARK: - GooglePay
struct CheckoutsResponseV2GooglePay: Codable {
    let gatewayID, gatewayMerchantID, status: String?
    
    enum CodingKeys: String, CodingKey {
        case gatewayID = "gateway_id"
        case gatewayMerchantID = "gateway_merchant_id"
        case status
    }
}

// MARK: - SamsungPay
struct CheckoutsResponseV2SamsungPay: Codable {
    let serviceID: String?
    
    enum CodingKeys: String, CodingKey {
        case serviceID = "service_id"
    }
}
