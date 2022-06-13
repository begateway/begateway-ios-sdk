//
//  InitialViewController.swift
//  begateway.framework
//
//  Created by admin on 29.10.2021.
//

import UIKit

class InitialViewController: PaymentBasicViewController, PaymentBasicProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var numberCardLabel: UILabel!
    @IBOutlet weak var numberCardImageView: UIImageView!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderActiveIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var successImageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate: PaymentBasicProtocol?
    
    var activeCard: StoreCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activeCard = StoreCard.getActiveCard()
        self.initInterface()
        self.initUIFromOptions()
        self.initCard()
        
        guard let _ = self.activeCard else {
            fatalError("Error - Card is nll")
        }
    }
    
    func initInterface() {
        //        self.title = "Payment"
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTappedClose))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalizedString.LocalizedString(value: "Cancel"), style: .plain, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedString.LocalizedString(value: "Change"), style: .plain, target: self, action: #selector(changeTapped))
        
        self.titleLabel.text = LocalizedString.LocalizedString(value: "")
        
        self.loaderView.isHidden = true
        self.errorLabel.isHidden = true
        self.successView.isHidden = true
        
        self.initDefaultUIStyleByOptions(controllerView: self.view, payButton: self.payButton, titleLabel: nil, errorLabel: self.errorLabel)
    }
    
    func initCard() {
        if self.activeCard != nil {
            self.numberCardLabel.text = "\(self.activeCard!.first1)*** **** **** \(self.activeCard!.last4)"
            
            if let image = MainHelper.getCardImageByName(brandName: self.activeCard!.brand ?? "", bundle: Bundle(for: type(of: self))) {
                self.numberCardImageView.image = image
            }
            
            if self.activeCard?.token == nil {
                self.payButton.isHidden = true
                self.errorLabel.isHidden = false
                self.errorLabel.text = LocalizedString.LocalizedString(value: "Sorry, card without token")
            }
        }
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
        self.successView.isHidden = false
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
    
    @IBAction func closeTapped(_ sender: Any) {
        if self.sheetViewController?.options.useInlineMode == true {
            self.sheetViewController?.attemptDismiss(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func changeTapped(_ sender: Any) {
        let bundle = Bundle(for: type(of: self))
        
        let controller = CardsViewController.loadFromNib(bundle)
        controller.onSelectCard = {card in
            self.activeCard = card
            self.initCard()
        }
        
        self.sheetViewController?.setSizes([.fullscreen])
        self.navigationController?.pushViewController(controller, animated: false)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            
//        }
    }
    
    @IBAction func touchPay(_ sender: Any) {
        print("Touch")
        
        self.pay(card: RequestPaymentV2CreditCard(number: nil, verificationValue: nil, expMonth: nil, expYear: nil, holder: nil, token: self.activeCard?.token, saveCard: nil))
    }
    
    
    func initUIFromOptions() {
        if let options = BeGateway.instance.options {
            if options.textColor != nil {
                self.titleLabel.textColor = options.textColor
                self.numberCardLabel.textColor = options.textColor
            }
            
            if options.textFont != nil {
                self.titleLabel.font = options.textFont
                self.numberCardLabel.font = options.textFont
            }
            
            if options.colorTitle != nil {
                self.titleLabel.textColor = options.colorTitle
            }
            
            if options.fontTitle != nil {
                self.titleLabel.font = options.fontTitle
            }
        }
    }
    
    
}
