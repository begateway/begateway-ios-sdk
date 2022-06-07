//
//  CurrencyMultiplayerChecker.swift
//  begateway_Example
//
//  Created by Igor on 30.05.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

class CurrencyMultiplayerChecker {
    static func checkCurrencyCode(code : String) -> Double {
        let lowerCased = code.lowercased()
        if let currencies = loadJson(filename: "Currency") {
            if let currency = currencies[lowerCased] {
                return Double(currency.subunitToUnit)
            }
        }
        return 100.0
    }
}
