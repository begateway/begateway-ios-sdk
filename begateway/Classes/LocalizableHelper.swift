//
//  LocalizableHelper.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/19/19.
//

import Foundation

class BGLocalization {
    static func localizable(_ key: String) -> String {
        return NSLocalizedString(key, bundle: Bundle(for: BGPaymentModule.self), comment: "")
    }
    static var begatewayFormHintCardNumber: String {
        return BGLocalization.localizable("begateway_form_hint_card_number")
    }
    static var begatewayFormHintExpiration: String {
        return BGLocalization.localizable("begateway_form_hint_expiration")
    }
    static var begatewayFormHintCardholderName: String {
        return BGLocalization.localizable("begateway_form_hint_cardholder_name")
    }
    static var begatewayCVV: String {
        return BGLocalization.localizable("begateway_cvv")
    }
    static var begatewayCVC: String {
        return BGLocalization.localizable("begateway_cvc")
    }
    static var begatewayCID: String {
        return BGLocalization.localizable("begateway_cid")
    }
    static var begatewayCVN: String {
        return BGLocalization.localizable("begateway_cvn")
    }
    static var begatewayMonth: String {
        return BGLocalization.localizable("begateway_month")
    }
    static var begatewayYear: String {
        return BGLocalization.localizable("begateway_year")
    }
    static var begatewayCardNumberRequired: String {
        return BGLocalization.localizable("begateway_card_number_required")
    }
    static var begatewayCardNumberInvalid: String {
        return BGLocalization.localizable("begateway_card_number_invalid")
    }
    static var begatewayExpirationRequired: String {
        return BGLocalization.localizable("begateway_expiration_required")
    }
    static var begatewayExpirationInvalid: String {
        return BGLocalization.localizable("begateway_expiration_invalid")
    }
    static var begatewayCardholderNameRequired: String {
        return BGLocalization.localizable("begateway_cardholder_name_required")
    }
    static var begatewaySavecard: String {
        return BGLocalization.localizable("begateway_savecard")
    }
    static var begatewayButtonPay: String {
        return BGLocalization.localizable("begateway_button_pay")
    }
    static func begatewaySecureInfo(_ value: String) -> String {
        return BGLocalization.localizable("begateway_secure_info") + value
    }
    static var cancel: String {
        return Bundle(for: UIApplication.self).localizedString(forKey: "Cancel", value: nil, table: nil)
    }
    static var done: String {
        return Bundle(for: UIApplication.self).localizedString(forKey: "Done", value: nil, table: nil)
    }
    static var next: String {
        return Bundle(for: UIApplication.self).localizedString(forKey: "Next", value: nil, table: nil)
    }
    static var close: String {
        return Bundle(for: UIApplication.self).localizedString(forKey: "Close", value: nil, table: nil)
    }
}
