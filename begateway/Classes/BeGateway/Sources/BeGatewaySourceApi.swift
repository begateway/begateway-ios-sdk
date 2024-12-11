//
//  BepaidApi.swift
//  begateway
//
//  Created by admin on 28.10.2021.
//

import Foundation

let applePayString = "/apple_pay/payment"

class BeGatewaySourceApi: ServiceApi {
    var pubKey: String
    var domain: String = "https://checkout.begateway.com/ctp/api"
    var options: BeGatewayOptions?

    init(options: BeGatewayOptions) {
        self.pubKey = options.clientPubKey
        self.domain = options.endpoint
        self.options = options
    }

    func sendApplePayment(uploadDataModel: RequestPaymentAppleV2, completionHandler: ((ResponsePaymentV2?) -> Void)?, failureHandler:((String) -> Void)?) {
        self.postMethod(with: self.domain + applePayString, uploadDataModel: uploadDataModel, completionHandler: completionHandler, failureHandler: failureHandler)
    }

    func sendPayment(uploadDataModel: RequestPaymentV2, completionHandler: ((ResponsePaymentV2?) -> Void)?, failureHandler:((String) -> Void)?) {
        self.postMethod(with: self.domain + "/payments", uploadDataModel: uploadDataModel, completionHandler: completionHandler, failureHandler: failureHandler)
    }

    func checkStatus(token: String, completionHandler: ((CheckoutsResponseStatusV2?) -> Void)?, failureHandler:((String) -> Void)?) {
        self.getMethod(with: self.domain + "/checkouts/\(token)", completionHandler: completionHandler, failureHandler: failureHandler)
    }
    
    func checkout(request: BeGatewayRequest, completionHandler: ((CheckoutsResponseV2?) -> Void)?, failureHandler:((String) -> Void)?) {

        guard let options = self.options else {
            fatalError("Error - Options is nll")
        }
        
        let uploadDataModel = CheckoutsRequestV2(
            checkout: CheckoutsRequestV2Checkout(
                order: CheckoutsRequestV2Order(
                    additionalData: CheckoutsRequestV2AdditionalData(contract: [
                        "recurring",
                        "card_on_file"
                    ]),
                    amount: CurrencyHelper.getCents(amount: request.amount, currency: request.currency),
                    currency: request.currency,
                    orderDescription: request.requestDescription,
                    trackingID: request.trackingID
                ),
                settings: CheckoutsRequestV2Settings(
                    autoReturn: 0,
                    returnURL: options.resultUrl,
                    language: options.language,
                    notificationUrl: options.notificationURL,
                    saveCardToggle: CheckoutsRequestV2SettingSaveCardToggle(
                        customerContract: !options.isToogleSaveCard
                    )
                ),
                test: options.test,
                transactionType: options.transaction_type,
                version: 2.1
            )
        )

        self.postMethod(
            with: self.domain + "/checkouts",
            uploadDataModel: uploadDataModel,
            completionHandler: completionHandler,
            failureHandler: failureHandler
        )
    }
}
