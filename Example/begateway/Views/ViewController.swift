//
//  ViewController.swift
//  begateway
//
//  Created by alimath.work@gmail.com on 08/29/2019.
//  Copyright (c) 2019 alimath.work@gmail.com. All rights reserved.
//

import UIKit
import begateway
import Foundation

class ViewController: UIViewController {
    let module = BGPaymentModule()
    let order = BGOrder(amount: 200, currency: "USD", description: "test", trackingId: "my_custom_variable")
    var cardToken: String?
    var lastPayCardInfo: BGCardInfo?
    
    @IBAction func payWithPublicKey3DSec(_ sender: Any) {
        module.pay(publicKey: Constants.publicKeyWith3DSecure, order: order)
    }
    @IBAction func payWithPublicKeyWithout3DSec(_ sender: Any) {
        module.pay(publicKey: Constants.publicKey, order: order)
    }
    @IBAction func payWithCheckoutObject3DSecure(_ sender: Any) {
        guard let checkoutData = Constants.testCheckoutJSON3DSecure.data(using: .utf8) else {
            self.showSimpleAlert(title: "Error", message: "Cannot convert checkout string to data")
            return
        }
        do {
            // make sure, that you set valid payment token in 'testCheckoutJSON3DSecure'
            // you can become it with making post request to your payment provider base url with prefix /checkouts
            let checkoutObject = try JSONDecoder().decode(BGCheckoutResponseObject.self, from: checkoutData)
            module.pay(checkout: checkoutObject)
        } catch let error {
            self.showSimpleAlert(title: "Error", message: error.localizedDescription)
        }
    }
    @IBAction func payWithCheckoutObjectWithout3DSecure(_ sender: Any) {
        guard let checkoutData = Constants.testCheckoutJSON.data(using: .utf8) else {
            self.showSimpleAlert(title: "Error", message: "Cannot convert checkout string to data")
            return
        }
        do {
            // make sure, that you set valid payment token in 'testCheckoutJSON3DSecure'
            // you can become it with making post request to your payment provider base url with prefix /checkouts
            let checkoutObject = try JSONDecoder().decode(BGCheckoutResponseObject.self, from: checkoutData)
            module.pay(checkout: checkoutObject)
        } catch let error {
            self.showSimpleAlert(title: "Error", message: error.localizedDescription)
        }
    }
    @IBAction func payWithCardToken(_ sender: Any) {
        guard let cardToken = cardToken else {
            self.showSimpleAlert(title: "Warning", message: "No card token.\nPlease, make success operation with \"Pay With Public Key Without 3D\" button to activate it.")
            return
        }
        isLoading = true
        let card = BGTokenizedCard(token: cardToken)
        // please insert payment token. You can become it with making post request to your payment provider base url with prefix /checkouts
        module.pay(publicKey: Constants.publicKey, order: order, tokenizedCard: card)
    }
    @IBAction func payWithTokenizedCardFail() {
        isLoading = true
        let card = BGTokenizedCard(token: "invalid card token")
        let order = BGOrder(amount: 200, currency: "USD", description: "test", trackingId: "my_custom_variable")
        // please insert payment token, you can become it with making post request to your payment provider base url with prefix /checkouts
        module.pay(publicKey: Constants.publicKey, order: order, tokenizedCard: card)
    }
    
    private let loadingBack = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
    override func viewDidLoad() {
        super.viewDidLoad()
        module.delegate = self
        module.settings.endpoint = "https://checkout.bepaid.by/ctp/api"
        module.settings.returnURL = "https://testPayApp.com"
        module.settings.notificationURL = "https://testPayApp.com"
        
        customizeView()
    }
    
    private var isLoading = false {
        didSet {
            if Thread.isMainThread {
                self.loadingBack.isHidden = !self.isLoading
                self.isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = !self.isLoading
            } else {
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync {
                        self.loadingBack.isHidden = !self.isLoading
                        self.isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = !self.isLoading
                    }
                })
            }
        }
    }
    private func customizeView() {
        loadingIndicator.hidesWhenStopped = true
        loadingBack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        isLoading = false
        loadingBack.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingBack)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingBack.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingBack.topAnchor.constraint(equalTo: view.topAnchor),
            loadingBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingBack.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingBack.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingBack.centerYAnchor)
            ])
    }
}

extension ViewController: BGPaymentModuleDelegate {
    func bgPaymentResult(status: BGPaymentModuleStatus) {
        isLoading = false
        var alertMessage = ""
        switch status {
        case .success(let cardInfo):
            self.lastPayCardInfo = cardInfo
            self.cardToken = cardInfo?.token
            alertMessage = "Success\n" + (self.cardToken != nil ? "Card Token saved" : "Card Token not saved")
        case .canceled:
            alertMessage = "Operation was canceled by user"
        case .error(let error):
            alertMessage = "Error: \(error.localizedDescription)"
        case .failure(let message):
            alertMessage = "Failure: \(message)"
        }
        self.showSimpleAlert(title: "Payments status", message: alertMessage)
    }
}
