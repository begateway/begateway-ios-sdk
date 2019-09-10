//
//  BGPaymentResponseObject.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

enum BGPaymentsResponseStatus: String, Codable {
    case successful
    case error
    case failed
    case incomplete
}

struct BGPaymentResponseObject: Codable {
    var message: String?
    var status: BGPaymentsResponseStatus
    var token: String?
    var url: String?
    var transactionType: String?
    var uid: String?
    var bankCode: String?
    var authCode: String?
    var threeDSecureVerification: BG3dSecVerificationObject?
    var card: BGCardInfo?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case token = "token"
        case url = "url"
        case transactionType = "transaction_type"
        case uid = "uid"
        case bankCode = "bank_code"
        case authCode = "authCode"
        case threeDSecureVerification = "three_d_secure_verification"
        case card = "credit_card"
    }
}
