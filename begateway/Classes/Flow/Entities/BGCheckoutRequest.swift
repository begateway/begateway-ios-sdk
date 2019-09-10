//
//  BGCheckoutRequest.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

public struct BGCheckoutRequest: Codable {
    public var checkout: BGCheckout
    
    init(checkout: BGCheckout) {
        self.checkout = checkout
    }
    enum CodingKeys: String, CodingKey {
        case checkout = "checkout"
    }
}

public enum BGTransactionType: String, Codable {
    case payment
}

public struct BGCheckout: Codable {
    public var iframe: Bool?
    public var test: Bool?
    public var transactionType: BGTransactionType
    public var attempts: Int?
    public var publicKey: String?
    public var order: BGOrder
    public var customer: BGCustomer?
    public var settings: BGCheckoutSettings?
    
    init(
        iframe: Bool?,
        test: Bool?,
        transactionType: BGTransactionType,
        attempts: Int?,
        publicKey: String?,
        order: BGOrder,
        customer: BGCustomer?,
        settings: BGCheckoutSettings?
        ) {
        self.iframe = iframe
        self.test = test
        self.transactionType = transactionType
        self.attempts = attempts
        self.publicKey = publicKey
        self.order = order
        self.customer = customer
        self.settings = settings
    }
    
    enum CodingKeys: String, CodingKey {
        case iframe = "iframe"
        case test = "test"
        case transactionType = "transaction_type"
        case attempts = "attempts"
        case publicKey = "public_key"
        case order = "order"
        case customer = "customer"
        case settings = "settings"
    }
}
