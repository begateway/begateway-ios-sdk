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
    
    public init(amount: Double, currency: String, requestDescription: String, trackingID: String, card: BeGatewayRequestCard? = nil, recepient: BeGatewayRequestRecipient? = nil, customer: BeGatewayRequestCustomer? = nil) {
        self.amount = amount
        self.currency = currency
        self.requestDescription = requestDescription
        self.trackingID = trackingID
        self.card = card
        self.recipient = recepient
        self.customer = customer
    }
    
    public var isEmpty: Bool {
        get {
            return self.amount == 0 || self.currency.isEmpty
        }
    }
        
    
}
