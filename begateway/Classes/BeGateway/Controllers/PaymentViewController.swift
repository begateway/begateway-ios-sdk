//
//  PaymentViewController.swift
//  begateway.framework
//
//  Created by admin on 29.10.2021.
//

import UIKit
import PassKit

class PaymentViewController: PaymentBasicViewController, UITextFieldDelegate, PaymentBasicProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var creditCardImageView: UIImageView!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var expireDateTextField: UITextField!
    
    @IBOutlet weak var cvcLabel: UILabel!
    @IBOutlet weak var cvcTextField: UITextField!
    
    @IBOutlet weak var nameOnCardView: UIView!
    @IBOutlet weak var nameOnCardLabel: UILabel!
    @IBOutlet weak var nameOnCardTextField: UITextField!
    
    @IBOutlet weak var saveDetailsView: UIView!
    @IBOutlet weak var saveDetailsLabel: UILabel!
    @IBOutlet weak var saveDetailsSwitch: UISwitch!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderActiveIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var successImageView: UIImageView!
    
    weak var delegate: PaymentBasicProtocol?
    
    var isSaveCard: Bool = false
    var currentTypeCard: CardTypePattern? = nil
    var tokenForRequest: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initInterfaceByOptions()
        self.initInterface()
        self.saveDetailsSwitch.isOn = false
        self.localize()
    }
    
    
    private func localize() {
        self.cardNumberLabel.text = BeGateway.instance.options?.titleCardNumber
        self.expireDateLabel.text = BeGateway.instance.options?.titleExpiryDate
        self.cvcLabel.text = BeGateway.instance.options?.titleCVC
        self.nameOnCardLabel.text = BeGateway.instance.options?.cardHolderName
        self.saveDetailsLabel.text = BeGateway.instance.options?.titleToggle
        self.payButton.titleLabel?.text = BeGateway.instance.options?.titleButton
    }
    
    func initInterface() {
        if BeGateway.instance.options?.onDetachFromCamera != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedString.LocalizedString(value: "Scan by camera"), style: .plain, target: self, action: #selector(detachFromPhoto))
        }
//        else {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedString.LocalizedString(value: "Close"), style: .plain, target: self, action: #selector(closeTapped))
//        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalizedString.LocalizedString(value: "Cancel"), style: .plain, target: self, action: #selector(closed))
        
        
        let text = BeGateway.instance.options?.title
        
        if text != nil && text != "" {
            self.titleLabel.text = text
        } else {
            self.titleLabel.text = LocalizedString.LocalizedString(value: "")
        }
        
        //        hidden all items for other steps
        self.loaderView.isHidden = true
        self.payButton.isHidden = true
        self.errorLabel.isHidden = true
        self.viewSuccess.isHidden = true
        
        self.cardNumberTextField.delegate = self
        self.expireDateTextField.delegate = self
        self.cvcTextField.delegate = self
        self.nameOnCardTextField.delegate = self
        
        self.cardNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.expireDateTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.cvcTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.nameOnCardTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        // init visibility
        if BeGateway.instance.options?.isToogleCardNumber ?? false {
            self.cardNumberView.isHidden = true
        }
        
        if BeGateway.instance.options?.isToogleExpiryDate ?? false && BeGateway.instance.options?.isToogleCVC ?? false {
            self.dateView.isHidden = true
        } else {
            if BeGateway.instance.options?.isToogleExpiryDate ?? false {
                self.expireDateLabel.isHidden = true
                self.expireDateTextField.isHidden = true
            }
            
            if BeGateway.instance.options?.isToogleCVC ?? false {
                self.cvcLabel.isHidden = true
                self.cvcTextField.isHidden = true
            }
        }
        
        if BeGateway.instance.options?.isToogleCardHolderName ?? false {
            self.nameOnCardView.isHidden = true
        }
        
        if BeGateway.instance.options?.isToogleSaveCard ?? false {
            self.saveDetailsView.isHidden = true
            self.isSaveCard = false
        }
        
        
//        self.cardNumberTextField.becomeFirstResponder()
        
        //        for test
        if let card = BeGateway.instance.request?.card{
            self.cardNumberTextField.text = card.number
            self.expireDateTextField.text = card.date
            self.cvcTextField.text = card.verificationValue
            self.nameOnCardTextField.text = card.holder
            self.creditCardImageView.image = MainHelper.getCardImageByNumberCard(cardNumber: card.number ?? "", bundle: Bundle(for: type(of: self)))
            self.validateRequiredFields()
        }
    }
    
    
    
    @IBAction func detachFromPhoto(_ sender: Any) {
        BeGateway.instance.options?.onDetachFromCamera?(){card in
            if let card = card {
                self.cardNumberTextField.text = card.number
                self.expireDateTextField.text = card.date
                self.cvcTextField.text = card.verificationValue
                self.nameOnCardTextField.text = card.holder
                self.creditCardImageView.image = MainHelper.getCardImageByNumberCard(cardNumber: card.number ?? "", bundle: Bundle(for: type(of: self)))
                self.validateRequiredFields()
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        if self.sheetViewController?.options.useInlineMode == true {
            self.sheetViewController?.attemptDismiss(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func detailsValueChanged(_ sender: Any) {
        self.isSaveCard = self.saveDetailsSwitch.isOn
        print(self.isSaveCard)
    }
    
    func processPayment(isActive: Bool){
        self.payButton.isHidden = isActive
        self.loaderView.isHidden = !isActive
        
        if isActive{
            self.loaderActiveIndicator.startAnimating()
        } else {
            self.loaderActiveIndicator.stopAnimating()
        }
        
    }
    
    func processPaymentSuccess() {
        self.delegate?.processPaymentSuccess()
        self.payButton.isHidden = true
        self.loaderView.isHidden = true
        self.viewSuccess.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true)
        }
    }
    
    func outError(error: String) {
        self.delegate?.outError(error: error)
        self.errorLabel.isHidden = false
        self.errorLabel.text = BeGateway.instance.options?.errorTitle ?? error
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.errorLabel.text = ""
            self.errorLabel.isHidden = true
        }
    }
    
    @IBAction func payTouch(_ sender: Any) {
        print("Touch")
        
        self.pay(card: RequestPaymentV2CreditCard(
            number: self.cardNumberTextField.text?.replacingOccurrences(of: " ", with: ""),
            verificationValue: self.cvcTextField.text,
            expMonth: self.expireDateTextField.text != nil ? self.expireDateTextField.text![0..<2] : nil,
            expYear: self.expireDateTextField.text != nil ? "20" + self.expireDateTextField.text![3..<5] : nil,
            holder: self.nameOnCardTextField.text,
            token: nil
        ), isSaveCard: self.isSaveCard, tokenForRequest: self.tokenForRequest)
    }
    
    // MARK:: UITextField Delegates
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.validateRequiredFields()
    }
    
    @objc func closed() {
        dismiss(animated: true, completion: nil)
    }
    
    func validateRequiredFields() {
        //        add validation by cards
        
//        self.payButton.isHidden =
//            self.cardNumberTextField.text?.isEmpty ?? true ||
//            self.expireDateTextField.text?.isEmpty ?? true ||
//            self.cvcTextField.text?.isEmpty ?? true ||
//            self.nameOnCardTextField.text?.isEmpty ?? true ||
//            (self.expireDateTextField.text ?? "").count != 5
        
        self.payButton.isHidden = false
    }
    
    /// mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String, phone: String, replace: String = "[^0-9]") -> String {
        let numbers = phone.replacingOccurrences(of: replace, with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        
        guard let text = textField.text else { return false }
        var newString = (text as NSString).replacingCharacters(in: range, with: string)
        print("New string: \(newString)")
        
        switch textField {
        case self.cardNumberTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            if allowedCharacters.isSuperset(of: characterSet) {
                //                if ((newString.replacingOccurrences(of: " ", with: "").count % 4) == 0 && newString.count > self.cardNumberTextField.text?.count ?? 0) {
                //                    newString += " "
                //                }
                
                
                var StringWithDelimiter = ""
                for (index, item) in newString.replacingOccurrences(of: " ", with: "").enumerated() {
                    
                    if index > 0 && (index % 4) == 0{
                        StringWithDelimiter += " "
                    }
                    
                    StringWithDelimiter.append(item)
                }
                
                self.cardNumberTextField.text = StringWithDelimiter
                self.validateRequiredFields()
                
                self.currentTypeCard = nil
                
                for pattern in cardPatterns {
                    if let _ = self.cardNumberTextField.text?.replacingOccurrences(of: " ", with: "").range(of: pattern.pattern, options: .regularExpression) {
                        self.currentTypeCard = pattern
                        print("Type of card - \(pattern.type)")
                        break
                    }
                }
                
                self.creditCardImageView.image = UIImage(named: currentTypeCard?.image ?? "CreditCard", in: Bundle(for: type(of: self)), compatibleWith: nil)
                
                
                return false
            } else {
                self.validateRequiredFields()
                return false
            }
            
        case self.expireDateTextField:
            
            if newString.count == 1 && Int(newString) ?? 0 < 10 &&  Int(newString) ?? 0 > 1 {
                newString = "0\(newString)"
            }
            else if newString.count == 3 && newString.contains("/") {
                //
            } else if newString.count == 2 && newString.contains("/") {
                self.expireDateTextField.text = "0" + newString
                self.validateRequiredFields()
                return false
            } else if newString.count == 2 && !newString.contains("/") {
                if Int(newString) ?? 0 > 12 {
                    self.expireDateTextField.text = String(12)
                    self.validateRequiredFields()
                    return false
                }
            } else if newString.count == 5 {
                let substring = String(newString[3..<newString.count])
                print(substring)
                let currentYear = Calendar.current.component(.year, from: Date())
                
                let yearLastDigital: String = String(currentYear)[2..<4]
                
                if Int(substring) ?? 0 < Int(yearLastDigital) ?? 0 {
                    newString = newString[0..<3] + yearLastDigital
                } else if Int(substring) ?? 0 > (Int(yearLastDigital) ?? 9999 + 5) {
                    newString = newString[0..<3] + String((Int(yearLastDigital) ?? 9999) + 5)
                }
            }
            
            let formattedString = format(with: "XX/XX", phone: newString)
            self.expireDateTextField.text = formattedString
            self.validateRequiredFields()
            return false
            
        default:
            if textField != self.nameOnCardTextField {
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                
                if allowedCharacters.isSuperset(of: characterSet) {
                    
                } else {
                    self.validateRequiredFields()
                    return false
                }
            }
        }
        
        self.validateRequiredFields()
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        
        switch textField {
        case self.cardNumberTextField:
            self.expireDateTextField.becomeFirstResponder()
        case self.expireDateTextField:
            self.cvcTextField.becomeFirstResponder()
        case self.cvcTextField:
            self.nameOnCardTextField.becomeFirstResponder()
        default:
            print("Other type")
            
        }
        
        return true;
    }
    
    // MARK: Other
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    
    // MARK: Interface UI
    func initInterfaceByOptions() {
        self.initDefaultUIStyleByOptions(controllerView: self.view, payButton: self.payButton, titleLabel: self.titleLabel, errorLabel: self.errorLabel)
        
        //        common
        if let options = BeGateway.instance.options {
            //        toggle
            options.initStyleForCardNumber(label: self.cardNumberLabel, textField: self.cardNumberTextField)
            options.initStyleForExpireDate(label: self.expireDateLabel, textField: self.expireDateTextField)
            options.initStyleForCvc(label: self.cvcLabel, textField: self.cvcTextField)
            options.initStyleForHolderName(label: nameOnCardLabel, textField: nameOnCardTextField)
            
            //        toggle cvc
            self.saveDetailsLabel.text = options.titleToggle
            
            if options.textColor != nil {
                self.saveDetailsLabel.textColor = options.textColor
            }
            
            if options.textFont != nil {
                self.saveDetailsLabel.font = options.textFont
            }
        }
        
    }
    
    func initStyleForCardNumber() {
        
    }
    
}
