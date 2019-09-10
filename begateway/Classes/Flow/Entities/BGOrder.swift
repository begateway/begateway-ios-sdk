//
//  BGOrder.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

public struct BGOrder: Codable {
    public var amount: Int
    public var currency: String
    public var description: String
    public var trackingId: String
    private var additionalData: BGAdditionalData
    
    public init(amount: Int, currency: String, description: String, trackingId: String) {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.trackingId = trackingId
        self.additionalData = BGAdditionalData(contracts: [
            "recurring",
            "card_on_file"
            ])
    }
    
    enum CodingKeys: String, CodingKey {
        case trackingId = "tracking_id"
        case amount = "amount"
        case currency = "currency"
        case description = "description"
        case additionalData = "additional_data"
    }
}


struct BGAdditionalData: Codable {
    var contract: [String]
    
    init(contracts: [String]) {
        self.contract = contracts
    }
    enum CodingKeys: String, CodingKey {
        case contract = "contract"
    }
}
