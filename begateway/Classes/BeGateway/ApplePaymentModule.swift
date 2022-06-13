//
//  ApplePaymentModule.swift
//  begateway_Example
//
//  Created by Nikita on 19.02.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PassKit

class ApplePaymentModule  : NSObject, PKPaymentAuthorizationViewControllerDelegate {
    
    var link : BeGateway
    
    init(link : BeGateway) {
        self.link = link
    }
    var successCallback: () -> Void = {}
    var failureCallback: (String) -> Void = {(string) in }

func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment     payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    
    
    link.appleTokenReceived(payment: payment, completionHandler: { (Bool) in //success
        self.successCallback()
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }) { (stringDescription) in //failure
            self.failureCallback(stringDescription)
            print(stringDescription)
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        }
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}
