//
//  BegetWayCard.swift
//  begateway.framework
//
//  Created by admin on 29.10.2021.
//

import Foundation

public struct BeGatewayCard {
    public let createdAt: Date
    public let first1, last4: String
    public let brand: String?
}

public struct BeGatewayRequestCard{
    public let number, verificationValue, expMonth, expYear: String?
    public let holder: String?
    
    public init(number: String?, verificationValue: String?, expMonth: String?, expYear: String?, holder: String?) {
        self.number = number
        self.verificationValue = verificationValue
        self.expYear = expYear
        self.expMonth = expMonth
        self.holder = holder
    }
    
    public var date: String? {
        get {
            if self.expMonth != nil && self.expYear != nil {
                return self.expMonth! + "/" + self.expYear!
            }
            
            return ""
            
        }
    }
}
