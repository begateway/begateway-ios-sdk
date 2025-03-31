//
//  ApplePaymentModule.swift
//  begateway_Example
//
//  Created by Nikita on 19.02.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PassKit

class ApplePaymentModule: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    
    var link: BeGateway
    
    init(link: BeGateway) {
        self.link = link
    }
    
    var successCallback: () -> Void = {}
    var failureCallback: (String) -> Void = { string in }
    
    var didSucceed = false
    var incompleteResponse: ResponsePaymentV2Response?
    var lastError: String?
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        link.appleTokenReceived(payment: payment, completionHandler: { response in
            switch response.status {
            case "successful":
                self.didSucceed = true
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                if controller.presentingViewController == nil {
                    // If we call completion() after dismissing, didFinishWithStatus is NOT called.
                    self._finish()
                }
            case "incomplete":
                self.incompleteResponse = response
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            default:
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            }
        }) { (stringDescription) in // failure
            self.lastError = stringDescription
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            if controller.presentingViewController == nil {
                // If we call completion() after dismissing, didFinishWithStatus is NOT called.
                self._finish()
            }
        }
    }
    
    private func openWebView(with response: ResponsePaymentV2Response) {
        let bundle = Bundle(for: type(of: self))
        
        if let url = response.url {
            let webViewController = WebViewController.loadFromNib(bundle)
            webViewController.url = url
            webViewController.resultUrl = response.resultUrl
            
            webViewController.onBack = {
                self.lastError = "Return without 3D secure"
                self._finish()
            }
            
            webViewController.onSuccess = {
                guard !self.didSucceed else { return }
                
                self.didSucceed = true
                webViewController.dismiss(animated: true)
                
                self._finish()
            }
            
            let navController = UINavigationController(rootViewController: webViewController)
            navController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
                
                var presentingVC = rootVC
                while let presented = presentingVC.presentedViewController {
                    presentingVC = presented
                }
                
                presentingVC.present(navController, animated: true)
            }
        } else {
            lastError = "Url is null"
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: {
            if let incompleteResponse = self.incompleteResponse {
                self.openWebView(with: incompleteResponse)
                self.incompleteResponse = nil
            }
        })
        
        _finish()
    }
    
    func _finish() {
        guard incompleteResponse == nil else { return }
        
        if didSucceed {
            self.successCallback()
        } else {
            if let error = lastError {
                self.failureCallback(error)
                lastError = nil
                print(error)
            } else {
                self.failureCallback("Apple Pay cancelled by user")
                print("Apple Pay cancelled by user")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.didSucceed = false // reset status variable
        })
    }
}
