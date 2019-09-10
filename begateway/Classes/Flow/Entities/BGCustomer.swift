//
//  BGCustomer.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

public struct BGCustomer: Codable {
    var country: String
    var firstName: String
    var lastName: String
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
