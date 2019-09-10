//
//  BGTokenizedCardPayment.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/10/19.
//

import Foundation

struct BGPayWithTokenizedCardRequest: Codable {
    var request: BGTokenizedCardPayment
    
    enum CodingKeys: String, CodingKey {
        case request = "request"
    }
}

struct BGTokenizedCardPayment: Codable {
    var token: String
    private let paymentMethod = "credit_card"
    var creditCard: BGTokenizedCard
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case paymentMethod = "payment_method"
        case creditCard = "credit_card"
    }
    
    init(paymentToken: String, tokenizedCard: BGTokenizedCard) {
        self.token = paymentToken
        self.creditCard = tokenizedCard
    }
}

struct BGTokenizedCardPaymentRequest: Codable {
    var request: BGTokenizedCardPayment
    
    enum CodingKeys: String, CodingKey {
        case request = "request"
    }
}
