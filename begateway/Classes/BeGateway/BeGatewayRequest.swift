//
//  BegetWayRequest.swift
//  begateway.framework
//
//  Created by admin on 29.10.2021.
//

import Foundation

public struct BeGatewayRequest {
    public let amount: Double
    public let currency, requestDescription, trackingID: String
    public var card: BeGatewayRequestCard?
    public var recipient: BeGatewayRequestRecipient?
    public var customer: BeGatewayRequestCustomer?
    public var paymentCustomer: BeGatewayPaymentCustomer?
    
    public init(amount: Double, currency: String, requestDescription: String, trackingID: String, card: BeGatewayRequestCard? = nil, recipient: BeGatewayRequestRecipient? = nil, customer: BeGatewayRequestCustomer? = nil, paymentCustomer: BeGatewayPaymentCustomer? = nil) {
        self.amount = amount
        self.currency = currency
        self.requestDescription = requestDescription
        self.trackingID = trackingID
        self.card = card
        self.recipient = recipient
        self.customer = customer
        self.paymentCustomer = paymentCustomer
    }
    
    public var isEmpty: Bool {
        get {
            return self.amount == 0 || self.currency.isEmpty
        }
    }
        
    
}
