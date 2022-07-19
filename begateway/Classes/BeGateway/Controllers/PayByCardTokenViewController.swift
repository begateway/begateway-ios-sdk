//
//  PayByTokenViewController.swift
//  begateway
//
//  Created by Igor on 19.07.2022.
//

import Foundation

class PayByCardTokenViewController: PaymentBasicViewController, PaymentBasicProtocol {
    
    weak var delegate: PaymentBasicProtocol?
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderActiveIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var successImageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var cardToken: String?
    
    func processPayment(isActive: Bool) {
        if isActive {
            loaderActiveIndicator.startAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.pay()
    }
    
    private func setupView() {
        errorLabel.isHidden = true
    }
    private func pay() {
        if self.cardToken != nil {
            self.pay(card: RequestPaymentV2CreditCard(number: nil, verificationValue: nil, expMonth: nil, expYear: nil, holder: nil, token: self.cardToken, saveCard: nil))
        } else {
            self.errorLabel.text = LocalizedString.LocalizedString(value: "Sorry, card without token")
            self.errorLabel.isHidden = false
        }
    }
    
    func processPaymentSuccess() {
        loaderActiveIndicator.stopAnimating()
        loaderView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true)
        }
    }
    
    func outError(error: String) {
        loaderActiveIndicator.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = error
    }
}
