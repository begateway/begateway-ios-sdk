//
//  MainHelper.swift
//  begateway.framework
//
//  Created by admin on 01.11.2021.
//

import UIKit

class MainHelper {
    static func getCardImage(number: String, bundle: Bundle?) -> (UIImage?, CardTypePattern?) {
        let currentTypeCard: CardTypePattern? = MainHelper.cardPatternFrom(cardNumber: number)
        
        return (UIImage(named: currentTypeCard?.image ?? "CreditCard", in: bundle, compatibleWith: nil), currentTypeCard)
    }
    
    static func getCardImageByName(brandName: String, bundle: Bundle?) -> UIImage? {
        for pattern in cardPatterns {
            if brandName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ==  pattern.type.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                
                return UIImage(named: pattern.image ?? "CreditCard", in: bundle, compatibleWith: nil)
            }
        }
        
        return nil
    }
    
    static func getCardImageByNumberCard(cardNumber: String, bundle: Bundle?) -> UIImage? {
        let currentTypeCard: CardTypePattern? = MainHelper.cardPatternFrom(cardNumber: cardNumber)
        
        return UIImage(named: currentTypeCard?.image ?? "CreditCard", in: bundle, compatibleWith: nil)
    }
    
    static func cardPatternFrom(cardNumber : String) -> CardTypePattern? {
        var currentTypeCard: CardTypePattern?
        
        let formattedString = cardNumber.replacingOccurrences(of: " ", with: "")
        for pattern in cardPatterns {
            if let _ = formattedString.range(of: pattern.pattern, options: .regularExpression) {
                currentTypeCard = pattern
                print("Type of card - \(pattern.type)")
                break
            }
        }
        
        return currentTypeCard
    }
    
    static func validateCardNumber(cardNumber: String) -> Bool {
        let currentTypeCard: CardTypePattern? = MainHelper.cardPatternFrom(cardNumber: cardNumber)
        let formattedString = cardNumber.replacingOccurrences(of: " ", with: "")
        
        if ((currentTypeCard?.length.contains(formattedString.count)) != nil) {
            if currentTypeCard?.luhn == true {
                return isLuhnValid(cardNumber: formattedString)
            }
            return true
        }
        
        return false
    }
    
    static func isLuhnValid(cardNumber: String) -> Bool {
            if cardNumber.isEmpty { return false }
            let reversed = cardNumber.reversed()
            var oddSum = 0
            var evenSum = 0
            for (index, item) in reversed.enumerated() {
                guard let digit = item.wholeNumberValue else {
                    print("card number has not number values")
                    return false
                }
                if index % 2 == 0 {
                    oddSum += digit
                } else {
                    evenSum += digit / 5 + (2 * digit) % 10
                }
            }
            return (oddSum + evenSum) % 10 == 0
    }
    
    static func validateCVC(cvcCode: String, cardNumber: String) -> Bool {
        let currentTypeCard: CardTypePattern? = MainHelper.cardPatternFrom(cardNumber: cardNumber)
        let isValid = currentTypeCard?.cvcLength.contains(cvcCode.count) ?? false
        return isValid
    }
    
    static func validateName(name : String) -> Bool {
        let formattedString = name.replacingOccurrences(of: " ", with: "")
        
        return formattedString.count > 0
    }
}
