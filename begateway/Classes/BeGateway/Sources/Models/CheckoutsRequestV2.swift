// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let checkoutsRequestV2 = try? newJSONDecoder().decode(CheckoutsRequestV2.self, from: jsonData)

import Foundation

// MARK: - CheckoutsRequestV2
public struct CheckoutsRequestV2: Codable {
    let checkout: CheckoutsRequestV2Checkout?
}

// MARK: - Checkout
public struct CheckoutsRequestV2Checkout: Codable {
    let order: CheckoutsRequestV2Order?
    let settings: CheckoutsRequestV2Settings?
    let test: Bool?
    let transactionType: String?
    let version: Double?
    let customer: CheckoutsRequestV2Customer?
    
    enum CodingKeys: String, CodingKey {
        case order, settings, test
        case transactionType = "transaction_type"
        case version
        case customer
    }
}

public struct CheckoutsRequestV2Customer: Codable {
    let address: String?
    let country: String?
    let city: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let state: String?
    let zip: String?
    let phone: String?
    let birthDate: String?
    
    enum CodingKeys: String, CodingKey {
        case address, country, city, email, state, zip, phone
        case firstName = "first_name"
        case lastName = "last_name"
        case birthDate = "birth_date"
    }
}

// MARK: - Order
public struct CheckoutsRequestV2Order: Codable {
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
public struct CheckoutsRequestV2AdditionalData: Codable {
    let contract: [String]?
    let recipient: CheckoutsRequestV2Receipient?
}

// MARK: - Recipient
public struct CheckoutsRequestV2Receipient: Codable {
    let accountNumber: String?
    let accountNumberType: String?
    
    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case accountNumberType = "account_number_type"
    }
}

// MARK: - Settings
public struct CheckoutsRequestV2Settings: Codable {
    let autoReturn: Int?
    let returnURL: String?
    let language: String?
    let notificationUrl: String?
    let saveCardToggle: CheckoutsRequestV2SettingSaveCardToggle?
    
    
    enum CodingKeys: String, CodingKey {
        case autoReturn = "auto_return"
        case returnURL = "return_url"
        case language
        case notificationUrl = "notification_url"
        case saveCardToggle = "save_card_toggle"
    }
}

public struct CheckoutsRequestV2SettingSaveCardToggle : Codable {
    let customerContract: Bool
    
    enum CodingKeys: String, CodingKey {
        case customerContract = "customer_contract"
    }
}
