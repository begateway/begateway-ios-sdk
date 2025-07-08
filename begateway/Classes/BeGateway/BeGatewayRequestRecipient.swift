//
//  BeGatewayRequestRecipient.swift
//  begateway
//
//  Created by Alexey Kostenko on 7.07.25.
//

import Foundation

public struct BeGatewayRequestRecipient {
    
    public let accountNumber, accountNumberType: String?
    
    public init(accountNumber: String?, accountNumberType: String?) {
        self.accountNumber = accountNumber
        self.accountNumberType = accountNumberType
    }
}
