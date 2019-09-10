//
//  BGPayment.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

struct BGPayment: Codable {
    var customer: BGCustomer?
    var paymentMethod: BGPaymentMethod
    var token: String
    var creditCard: BGCard
    
    init(
        customer: BGCustomer?,
        paymentMethod: BGPaymentMethod,
        token: String,
        creditCard: BGCard) {
        self.customer = customer
        self.paymentMethod = paymentMethod
        self.token = token
        self.creditCard = creditCard
    }
    
    enum CodingKeys: String, CodingKey {
        case customer = "customer"
        case paymentMethod = "payment_method"
        case token = "token"
        case creditCard = "credit_card"
    }
}
