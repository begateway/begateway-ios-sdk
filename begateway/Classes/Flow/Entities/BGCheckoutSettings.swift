//
//  BGCheckoutSettings.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

public struct BGCheckoutSettings: Codable {
    public var language: String
    public var returnUrl: String
    public var notificationUrl: String?
    public var autoReturn: Bool
    
    enum CodingKeys: String, CodingKey {
        case language = "language"
        case returnUrl = "return_url"
        case notificationUrl = "notification_url"
        case autoReturn = "auto_return"
    }
}
