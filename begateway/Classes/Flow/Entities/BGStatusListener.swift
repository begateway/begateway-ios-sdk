//
//  BGStatusListener.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

struct BGStatusListener: Codable {
    var status: BGPaymentsResponseStatus
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}

struct BGStatusListenerResponse: Codable {
    var checkout: BGStatusListener
    
    enum CodingKeys: String, CodingKey {
        case checkout = "checkout"
    }
}
