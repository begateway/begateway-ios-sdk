//
//  BGCardType.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/1/19.
//
import UIKit
import Security

extension BGCardType: CaseIterable {
    var icon: UIImage? {
        let bundle = Bundle(for: BGCardViewController.self)
        switch self {
        case .MIR:
            return UIImage(named: "bgmir", in: bundle, compatibleWith: nil)
        case .BELKART:
            return UIImage(named: "bgbelkart", in: bundle, compatibleWith: nil)
        case .VISA:
            return UIImage(named: "bgvisa", in: bundle, compatibleWith: nil)
        case .MASTER:
            return UIImage(named: "bgmastercard", in: bundle, compatibleWith: nil)
        case .DISCOVER:
            return UIImage(named: "bgdiscover", in: bundle, compatibleWith: nil)
        case .AMEX:
            return UIImage(named: "bgamex", in: bundle, compatibleWith: nil)
        case .DINERSCLUB:
            return UIImage(named: "bgdinersclub", in: bundle, compatibleWith: nil)
        case .JCB:
            return UIImage(named: "bgjcb", in: bundle, compatibleWith: nil)
        case .MAESTRO:
            return UIImage(named: "bgmaestro", in: bundle, compatibleWith: nil)
        case .UNIONPAY:
            return UIImage(named: "bgunionpay", in: bundle, compatibleWith: nil)
        case .UNKNOWN:
            return UIImage(named: "bgunknown", in: bundle, compatibleWith: nil)
        case .EMPTY:
            return UIImage(named: "bgunknown", in: bundle, compatibleWith: nil)
        }
    }
    var minCardLength: Int {
        switch self {
        case .MIR, .BELKART, .VISA, .MASTER, .DISCOVER:
            return 16
        case .AMEX:
            return 15
        case .DINERSCLUB:
            return 14
        case .JCB:
            return 16
        case .MAESTRO:
            return 12
        case .UNIONPAY:
            return 16
        case .UNKNOWN, .EMPTY:
            return 12
        }
    }
    var maxCardLength: Int {
        switch self {
        case .MIR, .BELKART, .VISA, .MASTER, .DISCOVER:
            return 16
        case .AMEX:
            return 15
        case .DINERSCLUB:
            return 14
        case .JCB:
            return 16
        case .MAESTRO:
            return 19
        case .UNIONPAY:
            return 19
        case .UNKNOWN, .EMPTY:
            return 19
        }
    }
    var securityCodeLength: Int {
        switch self {
        case .AMEX:
            return 4
        default:
            return 3
        }
    }
    var securityCodeName: String {
        switch self {
        case .DISCOVER, .AMEX:
            return "CID"
        case .MIR, .BELKART, .VISA, .DINERSCLUB, .JCB, .UNKNOWN, .EMPTY:
            return "CVV"
        case .MASTER, .MAESTRO:
            return "CVC"
        case .UNIONPAY:
            return "CVN"
        }
    }
}
public enum BGCardType: String, Codable {
    case MIR = "mir"
    case BELKART = "belkart"
    case VISA = "visa"
    case MASTER = "master"
    case DISCOVER = "discover"
    case AMEX = "amex"
    case DINERSCLUB = "dinersclub"
    case JCB = "jcb"
    case MAESTRO = "maestro"
    case UNIONPAY = "unionpay"
    case UNKNOWN
    case EMPTY
    
    internal var regexPre: String? {
        switch self {
        case .MAESTRO:
            return "^6\\d*"
        default:
            return nil
        }
    }
    internal var regex: String {
        switch self {
        case .MIR:
            return "^220[1-4]"
        case .BELKART:
            return "^9112"
        case .VISA:
            return "^4\\d*"
        case .MASTER:
            return "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)\\d*"
        case .DISCOVER:
            return "^(6011|65|64[4-9]|622)\\d*"
        case .AMEX:
            return "^3[47]\\d*"
        case .DINERSCLUB:
            return "^(36|38|30[0-5])\\d*"
        case .JCB:
            return "^3\\d*"
        case .MAESTRO:
            return "^(5018|5020|5038|5[6-9]|6020|6304|6703|6759|676[1-3])\\d*"
        case .UNIONPAY:
            return "^62\\d*"
        case .UNKNOWN:
            return "\\d+"
        case .EMPTY:
            return "^$"
        }
    }
    init(cardNumber: String) {
        for item in BGCardType.allCases {
            if let reg = try? NSRegularExpression(pattern: item.regex, options: .allowCommentsAndWhitespace) {
                let nnn = reg.numberOfMatches(in: cardNumber, range: NSRange(cardNumber.startIndex..., in: cardNumber))
                if nnn > 0 {
                    self = item
                    return
                }
            }
        }
        for item in BGCardType.allCases {
            guard let preReg = item.regexPre else { continue }
            if let reg = try? NSRegularExpression(pattern: preReg, options: .allowCommentsAndWhitespace) {
                let nnn = reg.numberOfMatches(in: cardNumber, range: NSRange(cardNumber.startIndex..., in: cardNumber))
                if nnn > 0 {
                    self = item
                    return
                }
            }
        }
        self = cardNumber.isEmpty ? .EMPTY : .UNKNOWN
    }
    
    internal static let AMEX_SPACE_INDICES = [4, 10]
    internal static let DEFAULT_SPACE_INDICES = [4, 8, 12]
    
    func isLuhnValid(cardNumber: String) -> Bool {
        if cardNumber.isEmpty { return false }
        let type = BGCardType(cardNumber: cardNumber)
        if !(type.minCardLength...type.maxCardLength ~= cardNumber.count) { return false }
        let reversed = cardNumber.reversed()
        var oddSum = 0
        var evenSum = 0
        for (index, item) in reversed.enumerated() {
            guard let digit = item.wholeNumberValue else {
                assertionFailure("card number has not number values")
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
}
