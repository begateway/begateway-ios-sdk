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
    
    static func formatAmount(amount: Int, currency: String) -> String {
        
        let multiplier = self.getMultiplier(code: currency)
        let formatter = NumberFormatter()
        let decimalAmount = Decimal(amount) / Decimal (multiplier)
        
        let countFraction = String(multiplier).filter{ $0 == "0" }.count
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = countFraction
        formatter.maximumFractionDigits = countFraction
        
        let strAmount = formatter.string(from: decimalAmount as NSDecimalNumber) ?? "0.00"
        
        return strAmount
    }
    
    static func getAmount(amount: Int, currency: String) -> NSDecimalNumber {
        let multiplier = self.getMultiplier(code: currency)
        let decimalAmount = Decimal(amount) / Decimal (multiplier)
        return decimalAmount as NSDecimalNumber
    }
    
    static func getCents(amount: Double, currency: String) -> Int {
        
        let currencyUnits : Decimal = Decimal(CurrencyHelper.getMultiplier(code: currency))
        let decimalAmount : Decimal = Decimal(amount) * currencyUnits
        
        let intAmount : NSDecimalNumber = pow(decimalAmount,1) as NSDecimalNumber
        return Int(truncating: intAmount)
    }
}
