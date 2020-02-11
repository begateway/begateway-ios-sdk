//
//  BGPaymentModule.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/7/19.
//

import Foundation
import UIKit

public enum BGPaymentModuleStatus {
    case success(card: BGCardInfo?)
    case error(Error)
    case canceled
    case failure(String)
}

public protocol BGPaymentModuleDelegate: class {
    func bgPaymentResult(status: BGPaymentModuleStatus)
}

extension BGPaymentModule: BGWebViewControllerDelegate {
    func dismissWebViewTouch() {
        self.bgWebView?.dismiss(animated: true, completion: nil)
        self.bgWebView = nil
        
        self.dissapearMe(with: .canceled)
    }
    
    func threeDSecDone() {
        if Thread.isMainThread {
            self.bgWebView?.dismiss(animated: true, completion: nil)
            self.bgWebView = nil
        } else {
            DispatchQueue.global().async(execute: {
                DispatchQueue.main.sync {
                    self.bgWebView?.dismiss(animated: true, completion: nil)
                    self.bgWebView = nil
                }
            })
        }
        self.checkPaymentStatus()
    }
}

extension BGPaymentModule: BGCardViewControllerDelegate {
    func dismissTouch() {
        dissapearMe(with: .canceled)
    }
    private func dissapearMe(with status: BGPaymentModuleStatus) {
        self.window?.endEditing(true)
        if self.window == nil {
            self.delegate?.bgPaymentResult(status: status)
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if Thread.isMainThread {
                self.window?.alpha = 0
            } else {
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync { [weak self] in
                        self?.window?.alpha = 0
                    }
                })
            }
        })
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.window = nil
                self?.delegate?.bgPaymentResult(status: status)
            }
        })
    }
    func payTouch(card: BGCard) {
        self.payWithCard(card: card)
    }
}

// MARK: pay
extension BGPaymentModule {
    func checkPaymentStatus() {
        self.cardVC?.isLoading = true
        guard let publicStoreKey = self.currentPublicKey else {
            self.dissapearMe(with: .error(BGErrors.noStoreKeySet))
            return
        }
        guard let payToken = self.currentPaymentToken else {
            self.dissapearMe(with: .error(BGErrors.noPaymentToken))
            return
        }
        if payToken.isEmpty {
            self.dissapearMe(with: .error(BGErrors.noPaymentToken))
            return
        }
        guard let url = URL(string: settings.endpoint + "/checkouts/\(payToken)") else {
            self.dissapearMe(with: .error(BGErrors.cantCheckOperationStatus))
            return
        }
        BGLoader.checkStatus(url: url,
                             publicKey: publicStoreKey,
                             paymentToken: payToken) { [weak self] (result) in
                                switch result {
                                case .error:
                                    self?.cardVC?.isLoading = false
                                    self?.dissapearMe(with: .error(BGErrors.cantCheckOperationStatus))
                                case .failed:
                                    self?.dissapearMe(with: .failure(""))
                                case .successful:
                                    self?.cardVC?.isLoading = false
                                    self?.dissapearMe(with: .success(card: nil))
                                case .incomplete:
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                        self?.cardVC?.isLoading = true
                                        self?.checkPaymentStatus()
                                    })
                                    
                                }
        }
    }
    
    func payWithCard(card: BGCard) {
        guard let url = URL(string: settings.endpoint + "/payments") else {
            self.dissapearMe(with: .error(BGErrors.endpointNotValid))
            return
        }
        guard let publicStoreKey = self.currentPublicKey else {
            self.dissapearMe(with: .error(BGErrors.noStoreKeySet))
            return
        }
        guard let payToken = self.currentPaymentToken else {
            self.dissapearMe(with: .error(BGErrors.noPaymentToken))
            return
        }
        if payToken.isEmpty {
            self.dissapearMe(with: .error(BGErrors.noPaymentToken))
            return
        }
        self.cardVC?.isLoading = true
        BGLoader.pay(
            paymentToken: payToken,
            url: url,
            publicKey: publicStoreKey,
            card: card,
            customer: nil,
            paymentMethod: .creditCard,
            payCallback)
    }
    
    private func payCallback(_ result: BGPayResult) {
        self.cardVC?.isLoading = false
        switch result {
        case .success(let response):
            if Thread.isMainThread {
                if !settings.styleSettings.isSaveCardCheckBoxVisible {
                    self.dissapearMe(with: .success(card: nil))
                } else if (self.cardVC?.saveCardSwitch.isOn ?? false) {
                    self.dissapearMe(with: .success(card: response.card))
                } else {
                    self.dissapearMe(with: .success(card: nil))
                }
            } else {
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync { [weak self] in
                        guard let self = self else { return }
                        if !self.settings.styleSettings.isSaveCardCheckBoxVisible {
                            self.dissapearMe(with: .success(card: nil))
                        } else if (self.cardVC?.saveCardSwitch.isOn ?? false) {
                            self.dissapearMe(with: .success(card: response.card))
                        } else {
                            self.dissapearMe(with: .success(card: nil))
                        }
                    }
                })
            }
        case .error(let error):
            self.dissapearMe(with: .error(error))
        case .need3dSec(let url):
            if Thread.isMainThread {
                let webView = BGWebViewController()
                self.bgWebView = webView
                webView.delegate = self
                self.cardVC?.isLoading = true
                self.cardVC?.present(webView, animated: true, completion: nil)
                webView.load3DSec(url: url, callbackURL: self.settings.returnURL)
            } else {
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync { [weak self] in
                        let webView = BGWebViewController()
                        self?.bgWebView = webView
                        self?.bgWebView?.delegate = self
                        self?.cardVC?.isLoading = true
                        self?.cardVC?.present(webView, animated: true, completion: nil)
                        webView.load3DSec(url: url, callbackURL: self?.settings.returnURL ?? "")
                    }
                })
            }
            
        case .incomplete:
            self.checkPaymentStatus()
        case .failure(let failureMessage):
            self.dissapearMe(with: .failure(failureMessage))
        }
    }
}

public class BGPaymentModule {
    public init() {}
    
    public weak var delegate: BGPaymentModuleDelegate?
    public var settings = BGPaymentSettings.standart
    
    public internal(set) var currentPublicKey: String?
    public internal(set) var currentOrder: BGOrder?
    public internal(set) var currentPaymentToken: String?
    private var cardVC: BGCardViewController?
    private var bgWebView: BGWebViewController?
    
    public var date = Date()
    
    private var window: UIWindow?
    
    public func pay(checkout: BGCheckoutResponseObject) {
        self.currentPublicKey = checkout.token
        self.currentPaymentToken = checkout.token
        self.brands = checkout.brands ?? []
        showCardView()
    }
    
    private func showCardView() {
        self.cardVC = BGCardViewController()
        cardVC?.brands = self.brands
        cardVC?.delegate = self
        cardVC?.colors = self.settings.cardViewColorsSettings
        cardVC?.paymentSettings = self.settings
        cardVC?.style = self.settings.styleSettings
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowLevel = (UIApplication.shared.keyWindow?.windowLevel ?? .normal) + 1
        window?.rootViewController = cardVC
        window?.makeKeyAndVisible()
        
        window?.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.window?.alpha = 1
        }
    }
    
    private var brands: [BGBrand] = []
    
    @available(*, deprecated, message: "Please, use method pay, with \"transactionType\" parameter")
    public func pay(publicKey: String, order: BGOrder) {
        self.pay(publicKey: publicKey, transactionType: .payment, order: order)
    }
    public func pay(publicKey: String,
                    transactionType: BGTransactionType,
                    order: BGOrder) {
        self.currentOrder = order
        self.currentPublicKey = publicKey
        guard let url = URL(string: settings.endpoint + "/checkouts") else {
            delegate?.bgPaymentResult(status: .error(BGErrors.endpointNotValid))
            return
        }
        guard let publicStoreKey = self.currentPublicKey else {
            self.delegate?.bgPaymentResult(status: .error(BGErrors.noStoreKeySet))
            return
        }
        showCardView()
        cardVC?.isLoading = true
        BGLoader.checkoutToken(
            settings: settings,
            transactionType: transactionType,
            checkoutURL: url,
            publicKey: publicStoreKey,
            order: order) { [weak self] (tokenResult) in
                self?.cardVC?.isLoading = false
                switch tokenResult {
                case .error(let error):
                    self?.dissapearMe(with: .error(error))
                case .success(let data):
                    self?.brands = data.brands
                    self?.currentPaymentToken = data.token
                }
        }
    }
    
    @available(*, deprecated, message: "Please, use method pay, with \"transactionType\" parameter")
    public func pay(publicKey: String, order: BGOrder, tokenizedCard: BGTokenizedCard) {
        self.pay(publicKey: publicKey, transactionType: .payment, order: order, tokenizedCard: tokenizedCard)
    }
    
    public func pay(publicKey: String,
                    transactionType: BGTransactionType,
                    order: BGOrder,
                    tokenizedCard: BGTokenizedCard) {
        self.currentPublicKey = publicKey
        guard let url = URL(string: settings.endpoint + "/checkouts") else {
            delegate?.bgPaymentResult(status: .error(BGErrors.endpointNotValid))
            return
        }
        guard let publicStoreKey = self.currentPublicKey, !publicStoreKey.isEmpty else {
            self.delegate?.bgPaymentResult(status: .error(BGErrors.noStoreKeySet))
            return
        }
        BGLoader.checkoutToken(
            settings: settings,
            transactionType: transactionType,
            checkoutURL: url,
            publicKey: publicStoreKey,
            order: order) { [weak self] (tokenResult) in
                guard let self = self else {
                    fatalError("payment module was dealloc from memory")
                }
                self.cardVC?.isLoading = false
                switch tokenResult {
                case .error(let error):
                    self.delegate?.bgPaymentResult(status: .error(error))
                case .success(let data):
                    self.brands = data.brands
                    self.currentPaymentToken = data.token
                    self.pay(paymentToken: data.token, card: tokenizedCard)
                }
        }
    }
    
    public func pay(paymentToken: String, card: BGTokenizedCard) {
        self.currentPublicKey = paymentToken
        self.currentPaymentToken = paymentToken
        guard let url = URL(string: settings.endpoint + "/payments") else {
            self.dissapearMe(with: .error(BGErrors.endpointNotValid))
            return
        }
        guard let publicStoreKey = self.currentPublicKey else {
            self.dissapearMe(with: .error(BGErrors.noStoreKeySet))
            return
        }
        guard let payToken = self.currentPaymentToken else {
            self.dissapearMe(with: .error(BGErrors.noPaymentToken))
            return
        }
        if payToken.isEmpty {
            self.dissapearMe(with: .error(BGErrors.noPaymentToken))
            return
        }
        BGLoader.pay(paymentToken: paymentToken, url: url, publicKey: publicStoreKey, tokenizedCard: card, payCallback)
    }
}
