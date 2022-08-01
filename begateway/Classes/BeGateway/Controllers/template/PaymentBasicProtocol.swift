//
//  PaymentProtocol.swift
//  begateway.framework
//
//  Created by admin on 01.11.2021.
//

import UIKit

protocol PaymentBasicProtocol: PaymentBasicViewController {
    func processPayment(isActive: Bool)
    func processPaymentSuccess()
    func outError(error: String)
    func isFinishedCheckingInterval() -> Bool
}

extension PaymentBasicProtocol {
    public func getBasicSourceApi() -> BeGatewaySourceApi {
        guard let options = BeGateway.instance.options else {
            fatalError("Error - Options is nll")
        }
        
        return BeGatewaySourceApi(options: options)
    }
    
    private func onError(_ error: String) {
        print("Error \(error)")
        BeGateway.instance.paymentFinishedWith(error: error)
        DispatchQueue.main.async {
            self.processPayment(isActive: false)
            self.outError(error: error)
            
            BeGateway.instance.failureHandler?(error)
        }
        
    }
    
    func isFinishedCheckingInterval() -> Bool{
        return self.didDisappear
    }
    
    public func pay(card: RequestPaymentV2CreditCard, isSaveCard: Bool = false, tokenForRequest: String? = nil)
    {
        print("Payment common")
        
        if let request = BeGateway.instance.request, !request.isEmpty {
            self.processPayment(isActive: true)
            
            if tokenForRequest == nil {
                self.getBasicSourceApi().checkout(request: request, completionHandler: {result in
                    if let token = result?.checkout?.token {
                        print("Token for operation is \"\(token)\"")
                        self.processPayment(token: token, card: card, isSaveCard: isSaveCard)
                    } else {
                        self.onError("token is null")
                    }
                }, failureHandler: {error in
                    self.onError(error)
                })
            } else {
                self.processPayment(token: tokenForRequest!, card: card, isSaveCard: isSaveCard)
            }
        }
    }
    
    public func processPayment(token: String, card: RequestPaymentV2CreditCard, isSaveCard: Bool = false)
    {
        print("Payment process")
        
        if let options = BeGateway.instance.options, let request = BeGateway.instance.request, !request.isEmpty {
            var _card: RequestPaymentV2CreditCard?
            
            if options.isEncryptedCreditCard{
                let encryptedCardInfo = RequestPaymentV2CreditCard.ecnrypted(card, with: options.clientPubKey)
                
                if let encryptionError = encryptedCardInfo.error {
                    self.onError("An error occurred while encrypting: \(encryptionError)")
                    return
                }
                
                if let encryptedCard = encryptedCardInfo.card {
                    _card = encryptedCard
                } else {
                    self.onError("An error occurred while encrypting")
                    return
                }
            } else {
                _card = card
            }
            
            if let card = _card {
                let uploadDataModel = RequestPaymentV2(
                    request: RequestPaymentV2Request(
                        creditCard: card,
                        //                                creditCard: encryptedCard,
                        paymentMethod: "credit_card",
                        token: token
                    ))
                
                self.getBasicSourceApi().sendPayment(uploadDataModel: uploadDataModel, completionHandler: {response in
                    
                    let status: String = response?.response?.status ?? "failed"
                    print("Status: \(status) for token : \(token)")
                    
                    let storeCard = StoreCard(
                        createdAt: Date(),
                        brand: response?.response?.creditCard?.brand,
                        icon: nil,
                        last4: response?.response?.creditCard?.last4 ?? "",
                        first1: response?.response?.creditCard?.first1 ?? "",
                        token: response?.response?.creditCard?.token ?? "",
                        isActive: isSaveCard
                    )
                    
                    switch status {
                    case "successful":
                        self.processPaymentSuccess()
                        BeGateway.instance.paymentWasSucceded()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            BeGateway.instance.completionHandler?(storeCard.to())
                        }
                        
                        if isSaveCard {
                            _ = StoreCard.addToUserDefaults(item: storeCard)
                        }
                    case "incomplete":
                        self.openWebView(response: response, storeCard: storeCard, isSaveCard: isSaveCard)
                    default:
                        self.onError("Error from Server")
                    }
                }, failureHandler: {error in
                    self.onError(error)
                })
            } else {
                self.onError("Card is null")
            }
        }
    }
    
    private func openWebView(response: ResponsePaymentV2?, storeCard: StoreCard, isSaveCard: Bool) {
        let bundle = Bundle(for: type(of: self))
        
        if let url = response?.response?.url {
            if let options = BeGateway.instance.options, let token = response?.response?.token {
                let controller = WebViewController.loadFromNib(bundle)
                controller.url = url
                controller.resultUrl = response?.response?.resultUrl
                
                controller.onBack = {
                    self.onError("Return without 3D secure")
                }
                controller.onSuccess = {
                    self.startCheckingStatus(token: token, storeCard: storeCard, isSaveCard: isSaveCard, step: options.delayCheckingSec, maxSteps: options.maxCheckingAttempts)
                }
                
                self.navigationController?.pushViewController(controller, animated: false)
            } else {
                self.onError("Token is null")
            }
        } else {
            self.onError("Url is null")
        }
    }
    
    func startCheckingStatus(token: String, storeCard: StoreCard, isSaveCard: Bool, step: Double = 5.0, maxSteps: Int = 30, iteration: Int = 0) {
        
        if iteration == 0 {
            self.didDisappear = false
        }
        
        if iteration < maxSteps && !self.isFinishedCheckingInterval() {
            self.getBasicSourceApi()
                .checkStatus(token: token, completionHandler: {response in
                    if let language = response?.checkout?.settings?.language {
                        BeGateway.instance.options?.language = language
                    }
                    let status: String = response?.checkout?.status ?? "failed"
                    print("Status: \(status)")
                    switch status {
                    case "successful":
                        self.processPaymentSuccess()
                        BeGateway.instance.paymentWasSucceded()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            BeGateway.instance.completionHandler?(storeCard.to())
                        }
                        
                        if isSaveCard {
                            _ = StoreCard.addToUserDefaults(item: storeCard)
                        }
                    case "incomplete" :
                        DispatchQueue.main.asyncAfter(deadline: .now() + step) {
                            self.startCheckingStatus(token: token, storeCard: storeCard, isSaveCard: isSaveCard, step: step, iteration: iteration + 1)
                        }
                    default:
                        self.onError("Error from Server")
                    }
                    
                }, failureHandler: {error in
                    self.onError(error)
                })
        } else {
            self.onError("Timeout")
        }
    }
    
    // MARK: Interface UI
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    func initDefaultUIStyleByOptions(
        controllerView: UIView?,
        payButton: UIButton?,
        titleLabel: UILabel?,
        errorLabel: UILabel?
        
    ) {
        if let options = BeGateway.instance.options {
            controllerView?.backgroundColor = options.backgroundColor
            
            //        title
            if options.textColor != nil {
                titleLabel?.textColor = options.textColor
            }
            
            if options.textFont != nil {
                titleLabel?.font = options.textFont
            }
            
            if options.fontTitle != nil {
                titleLabel?.font = options.fontTitle
            }
            
            if options.colorTitle != nil {
                titleLabel?.textColor = options.colorTitle
            }
            
            if options.title != nil {
                titleLabel?.text = options.title
            }
            
            
            //  button
            payButton?.backgroundColor = UIColor.systemBlue
            payButton?.setTitleColor(UIColor.white, for: .normal)
            payButton?.layer.cornerRadius = 5.0
            
            if options.colorButton != nil {
                payButton?.setTitleColor(options.colorButton, for: .normal)
            }
            
            if options.fontButton != nil {
                payButton?.titleLabel?.font = options.fontButton
            }
            
            if options.backgroundColorButton != nil {
                payButton?.backgroundColor = options.backgroundColorButton
            }
            
            //            payButton?.setTitle(options.titleButton + " \(request.amount)" + " " + (self.getSymbol(forCurrencyCode: request.currency) ?? ""), for: .normal)
            payButton?.setTitle(options.titleButton, for: .normal)
        }
        
    }
    
}
