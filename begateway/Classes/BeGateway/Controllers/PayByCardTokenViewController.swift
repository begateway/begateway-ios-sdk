//
//  PayByTokenViewController.swift
//  begateway
//
//  Created by Igor on 19.07.2022.
//

import Foundation

class PayByCardTokenViewController: PaymentBasicViewController, PaymentBasicProtocol {
    func processPayment(isActive: Bool) {
        //Empty implementation for backgound processing
    }
    
    func processPaymentSuccess() {
        //Empty implementation for backgound processing
    }
    
    func outError(error: String) {
        //Empty implementation for backgound processing
    }
    
    
    weak var delegate: PaymentBasicProtocol?
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderActiveIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var successImageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var cardToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.payWithCardToken()
    }
    
    private func setupView() {
        errorLabel.isHidden = true
    }
    
    public func payWithCardToken() {
        if self.cardToken != nil {
            self.pay(card: RequestPaymentV2CreditCard(number: nil, verificationValue: nil, expMonth: nil, expYear: nil, holder: nil, token: self.cardToken, saveCard: nil), customer: nil)
        } else {
            self.errorLabel.text = LocalizedString.LocalizedString(value: "Sorry, card without token")
            self.errorLabel.isHidden = false
        }
    }
}
