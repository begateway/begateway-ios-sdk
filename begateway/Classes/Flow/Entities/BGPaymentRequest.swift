//
//  BGPaymentRequest.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

struct BGPaymentRequest: Codable {
    var request: BGPayment
    
    init(request: BGPayment) {
        self.request = request
    }
    
    enum CodingKeys: String, CodingKey {
        case request = "request"
    }
}
