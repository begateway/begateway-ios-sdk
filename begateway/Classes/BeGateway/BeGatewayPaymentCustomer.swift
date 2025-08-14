//
//  BeGatewayPaymentCustomer.swift
//  begateway
//
//  Created by Alexey Kostenko on 11.07.25.
//

import Foundation

public struct BeGatewayPaymentCustomer {
    
    public let ip: String?
    public let deviceId: String?
    
    public init(ip: String?, deviceId: String?) {
        self.ip = ip
        self.deviceId = deviceId
    }
}
