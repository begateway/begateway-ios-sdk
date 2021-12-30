//
//  MainHelper.swift
//  begateway.framework
//
//  Created by admin on 01.11.2021.
//

import UIKit

class MainHelper {
    static func getCardImage(number: String, bundle: Bundle?) -> (UIImage?, CardTypePattern?) {
        var currentTypeCard: CardTypePattern? = nil
        
        for pattern in cardPatterns {
            if let _ = number.replacingOccurrences(of: " ", with: "").range(of: pattern.pattern, options: .regularExpression) {
                currentTypeCard = pattern
                print("Type of card - \(pattern.type)")
                break
            }
        }
        
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
        var currentTypeCard: CardTypePattern?
        
        for pattern in cardPatterns {
            if let _ = cardNumber.replacingOccurrences(of: " ", with: "").range(of: pattern.pattern, options: .regularExpression) {
                currentTypeCard = pattern
                print("Type of card - \(pattern.type)")
                break
            }
        }
        
        return UIImage(named: currentTypeCard?.image ?? "CreditCard", in: bundle, compatibleWith: nil)
    }
}
