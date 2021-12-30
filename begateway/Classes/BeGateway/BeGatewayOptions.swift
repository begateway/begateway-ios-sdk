//
//  BegetWayOptions.swift
//  begateway.framework
//
//  Created by admin on 29.10.2021.
//

import Foundation
import UIKit

public class BeGatewayOptions {
    public var clientPubKey: String
    
    var endpoint: String = "https://checkout.bepaid.by/ctp/api"
    var returnURL: String = "https://default_return_url.com"
    var notificationURL: String?
    
    var maxCheckingAttempts: Int = 30           // count of max attempts for checking status
    var delayCheckingSec: Double = 5
    
    private var language: String = "en"
    public var test: Bool = true
    
    public var title: String?
    public var fontTitle: UIFont?
    public var colorTitle: UIColor?
    
    public var titleCardNumber: String = LocalizeString.localizeString(value:"Card number")
    public var hintCardNumber: String = LocalizeString.localizeString(value:"Card number")
    public var cardNumber: String = LocalizeString.localizeString(value:"Card number")
    
    public var fontTitleCardNumber: UIFont?
    public var colorTitleCardNumber: UIColor?
    public var fontHintCardNumber: UIFont?
    public var colorHintCardNumber: UIColor?
    
    
    public var titleExpiryDate: String = LocalizeString.localizeString(value:"Expiration date")
    public var hintExpiryDate: String = LocalizeString.localizeString(value:"Expiration date")
    public var expiryDate: String = LocalizeString.localizeString(value:"Expiration date")
    
    public var fontTitleExpiryDate: UIFont?
    public var colorTitleExpiryDate: UIColor?
    public var fontHintExpiryDate: UIFont?
    public var colorHintExpiryDate: UIColor?
    
    
    public var titleCVC: String = LocalizeString.localizeString(value:"CVC")
    public var hintCVC: String = LocalizeString.localizeString(value:"CVC")
    public var cvc: String = LocalizeString.localizeString(value:"CVC")
    public var isSecureCVC: Bool = false
    
    public var fontTitleCVC: UIFont?
    public var colorTitleCVC: UIColor?
    public var fontHintCVC: UIFont?
    public var colorHintCVC: UIColor?
    
    
    public var titleCardHolderName: String = LocalizeString.localizeString(value:"Name on card")
    public var hintCardHolderName: String = LocalizeString.localizeString(value:"Name on card")
    public var cardHolderName: String = LocalizeString.localizeString(value:"Name on card")
    
    public var fontTitleCardHolderName: UIFont?
    public var colorTitleCardHolderName: UIColor?
    public var fontHintCardHolderName: UIFont?
    public var colorHintCardHolderName: UIColor?
    
    
    public var titleButton: String = LocalizeString.localizeString(value: "Pay")
    public var colorButton: UIColor?
    public var fontButton: UIFont?
    public var backgroundColorButton: UIColor?
    
    
    public var titleToggle: String = LocalizeString.localizeString(value:"Save card")
    public var errorTitle: String = LocalizeString.localizeString(value:"Sorry, incorrect data")
    
    
    public var textFont: UIFont?
    public var hintFont: UIFont?
    public var textColor: UIColor?
    public var hintColor: UIColor?
    public var backgroundColor: UIColor = UIColor.clear
    
    public var isToogleCardNumber: Bool = false
    public var isToogleExpiryDate: Bool = false
    public var isToogleCVC: Bool = false
    public var isToogleCardHolderName: Bool = false
    public var isToogleSaveCard: Bool = false
    
    
    //    other options
    public var isEncryptedCreditCard: Bool = false
    public var onDetachFromCamera: ((_ onSelected: ((BeGatewayRequestCard?) -> Void)?) -> Void)?
    
    public init(clientPubKey: String) {
        self.clientPubKey = clientPubKey
    }
}

extension BeGatewayOptions {
    func initStyleForRow(label: UILabel, textField: UITextField, colorLabel: UIColor?, fontLabel: UIFont?, colorTextField: UIColor?, fontTextField: UIFont?, title: String?, hint: String?)
    {
        //        default settings
        if self.textColor != nil {
            label.textColor = self.textColor
            textField.textColor = self.textColor
        }
        
        if self.textFont != nil {
            label.font = self.textFont
            textField.font = self.textFont
        }
        
        if self.hintFont != nil {
            textField.font = self.hintFont
        }
        
        if self.hintColor != nil {
            textField.placeHolderColor = self.hintColor
        }
        
        //        custom
        if fontLabel != nil {
            label.font = fontLabel
        }
        
        if colorLabel != nil {
            label.textColor = colorLabel
        }
        
        if fontTextField != nil {
            textField.font = fontTextField
        }
        
        if colorTextField != nil {
            textField.placeHolderColor = colorTextField
        }
        
        //        titles
        
        if title != nil {
            label.text = title
        }
        
        if hint != nil {
            textField.placeholder = hint
        }
    }
    
    func initStyleForCardNumber(label: UILabel, textField: UITextField) {
        self.initStyleForRow(label: label, textField: textField, colorLabel: self.colorTitleCardNumber, fontLabel: self.fontTitleCardNumber, colorTextField: self.colorHintCardNumber, fontTextField: self.fontHintCardNumber, title: self.titleCardNumber, hint: self.hintCardNumber)
    }
    
    func initStyleForExpireDate(label: UILabel, textField: UITextField) {
        self.initStyleForRow(label: label, textField: textField, colorLabel: self.colorTitleExpiryDate, fontLabel: self.fontTitleExpiryDate, colorTextField: self.colorHintExpiryDate, fontTextField: self.fontHintExpiryDate, title: self.titleExpiryDate, hint: hintExpiryDate)
    }
    
    func initStyleForCvc(label: UILabel, textField: UITextField) {
        self.initStyleForRow(label: label, textField: textField, colorLabel: self.colorTitleCVC, fontLabel: self.fontTitleCVC, colorTextField: self.colorHintCVC, fontTextField: self.fontHintCVC, title: self.titleCVC, hint: self.hintCVC)
        
        if self.isSecureCVC {
            textField.isSecureTextEntry = true
        }
    }
    
    func initStyleForHolderName(label: UILabel, textField: UITextField) {
        self.initStyleForRow(label: label, textField: textField, colorLabel: self.colorTitleCardHolderName, fontLabel: self.fontTitleCardHolderName, colorTextField: self.colorHintCardHolderName, fontTextField: self.fontHintCardNumber, title: self.titleCardHolderName, hint: self.hintCardHolderName)
    }
}