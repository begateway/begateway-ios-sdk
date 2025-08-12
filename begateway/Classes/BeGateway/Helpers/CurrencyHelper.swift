//
//  CurrencyHelper.swift
//  begateway_Example
//
//  Created by Igor on 30.05.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

class CurrencyHelper {
    static func getMultiplier(code : String) -> Int {
        let lowerCased = code.lowercased()
        if let currencies = loadJson(filename: "Currency") {
            if let currency = currencies[lowerCased] {
                return Int(currency.subunitToUnit)
            }
        }
        return 100
    }
    
    static func getAmount(amount: Int, currency: String) -> NSDecimalNumber {
        let multiplier = self.getMultiplier(code: currency)
        let decimalAmount = Decimal(amount) / Decimal (multiplier)
        return decimalAmount as NSDecimalNumber
    }

    static func getCents(amount: Double, currency: String) -> Int {
        let fractionDigits: Int
        if let localeId = Locale.availableIdentifiers.first(where: { Locale(identifier: $0).currencyCode == currency }) {
            let locale = Locale(identifier: localeId)
            if let currencyCode = locale.currencyCode {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.currencyCode = currencyCode
                fractionDigits = formatter.minimumFractionDigits
            } else {
                fractionDigits = 2
            }
        } else {
            fractionDigits = 2
        }
        
        let multiplier = pow(10.0, Double(fractionDigits))
        let minorUnits = (amount * multiplier).rounded()
        
        return Int(minorUnits)
    }
}
