//
//  BGCardViewColorsSettings.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/7/19.
//

import Foundation
import UIKit

public struct BGCardViewColorsSettings {
    let holderNameTextColor: UIColor
    let holderNameBackgroundColor: UIColor
    let holderNamePlaceholderColor: UIColor
    
    let cardNumberTextColor: UIColor
    let cardNumberBackgroundColor: UIColor
    let cardNumberInvalidColor: UIColor
    let cardNumberPlaceholderColor: UIColor
    
    let cvvTextColor: UIColor
    let cvvBackgroundColor: UIColor
    let cvvTextPlaceholderColor: UIColor
    
    let expirationDateTextColor: UIColor
    let expirationDateBackgroundColor: UIColor
    let expirationDatePlaceholderColor: UIColor
    
    let cancelTextColor: UIColor
    
    let payButtonBackgroundColor: UIColor
    let payButtonTextColor: UIColor
    
    let secureInfoTextColor: UIColor
    
    let saveCardSwitchTextColor: UIColor
    let saveCardSwitchTintOnColor: UIColor
    let saveCardSwitchTintOffColor: UIColor
    
    static var standart: BGCardViewColorsSettings {
        let settings = BGCardViewColorsSettings(
            holderNameTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            holderNameBackgroundColor: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0),
            holderNamePlaceholderColor: UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0),
            cardNumberTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            cardNumberBackgroundColor: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0),
            cardNumberInvalidColor: UIColor(red: 240.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0),
            cardNumberPlaceholderColor: UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0),
            cvvTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            cvvBackgroundColor: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0),
            cvvTextPlaceholderColor: UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0),
            expirationDateTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            expirationDateBackgroundColor: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0),
            expirationDatePlaceholderColor: UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0),
            cancelTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            payButtonBackgroundColor: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0),
            payButtonTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            secureInfoTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            saveCardSwitchTextColor: UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0),
            saveCardSwitchTintOnColor: UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 99.0/255.0, alpha: 1.0),
            saveCardSwitchTintOffColor: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        )
        return settings
    }
}
