//
//  BGPaymentResponse.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

class BGPaymentResponse: Codable {
    var response: BGPaymentResponseObject
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}
