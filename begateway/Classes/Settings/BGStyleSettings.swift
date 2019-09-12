//
//  StyleSettings.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/1/19.
//

import UIKit

public struct BGStyleSettings {
    public var isRequiredCardHolderName: Bool
    public var isRequiredCardNumber: Bool
    public var isRequiredCVV: Bool
    public var isRequiredExpDate: Bool
    public var isSaveCardCheckBoxVisible: Bool
    public var customPayButtonLabel: String?
    
    public static var standart: BGStyleSettings {
        return BGStyleSettings(
            isRequiredCardHolderName: true,
            isRequiredCardNumber: true,
            isRequiredCVV: true,
            isRequiredExpDate: true,
            isSaveCardCheckBoxVisible: true,
            customPayButtonLabel: nil)
    }
}
