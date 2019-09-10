//
//  BGCardInfo.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/11/19.
//

import Foundation

public struct BGCardInfo: Codable {
    public var holder: String?
    public var stamp: String?
    public var brand: String?
    public var last4: String?
    public var first1: String?
    public var bin: String?
    public var issuerCountry: String?
    public var issuerName: String?
    public var product: String?
    public var expMonth: Int?
    public var expYear: Int?
    public var token: String?
    
    enum CodingKeys: String, CodingKey {
        case holder = "holder"
        case stamp = "stamp"
        case brand = "brand"
        case last4 = "last_4"
        case first1 = "first_1"
        case bin = "bin"
        case issuerCountry = "issuer_country"
        case issuerName = "issuer_name"
        case product = "product"
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case token = "token"
    }
}
