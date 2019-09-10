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
    public var isMaskCVV: Bool
    public var isMaskCardNumber: Bool
    public var saveCardCheckboxDefaultState: Bool
    public var isSaveCardCheckBoxVisible: Bool
    public var isScanCardVisible: Bool
    public var isSecuredLabelVisible: Bool
    public var customPayButtonLabel: String?
    
    public static var standart: BGStyleSettings {
        return BGStyleSettings(
            isRequiredCardHolderName: true,
            isRequiredCardNumber: true,
            isRequiredCVV: true,
            isRequiredExpDate: true,
            isMaskCVV: true,
            isMaskCardNumber: true,
            saveCardCheckboxDefaultState: true,
            isSaveCardCheckBoxVisible: true,
            isScanCardVisible: true,
            isSecuredLabelVisible: true,
            customPayButtonLabel: nil)
    }
}
