//
//  BGTokenizedCard.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/10/19.
//

import Foundation

public struct BGTokenizedCard: Codable {
    private let number = "*"
    public var token: String
    
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case token = "token"
    }
    
    public init(token: String) {
        self.token = token
    }
}
