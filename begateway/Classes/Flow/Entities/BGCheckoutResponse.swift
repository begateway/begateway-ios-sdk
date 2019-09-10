//
//  BGCheckoutResponse.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

struct BGCheckoutResponse: Codable {
    var checkout: BGCheckoutResponseObject
    
    init(checkout: BGCheckoutResponseObject) {
        self.checkout = checkout
    }
    enum CodingKeys: String, CodingKey {
        case checkout = "checkout"
    }
}

public struct BGCheckoutResponseObject: Codable {
    var token: String
    var redirectUrl: String?
    var brands: [BGBrand]?
    var company: BGCompany?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case redirectUrl = "redirect_url"
        case brands = "brands"
        case company = "company"
        case description = "description"
    }
}

public struct BGBrand: Codable {
    var cardType: BGCardType
    var alternative: Bool
    enum CodingKeys: String, CodingKey {
        case alternative = "alternative"
        case cardType = "name"
    }
}

public struct BGCompany: Codable {
    var name: String
    var site: String
    enum CodingKeys: String, CodingKey {
        case site = "site"
        case name = "name"
    }
}
