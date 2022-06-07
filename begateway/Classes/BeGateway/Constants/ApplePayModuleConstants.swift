//
//  ApplePayModuleConstants.swift
//  begateway_Example
//
//  Created by Nikita on 20.02.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

struct ApplePayConstants {
  
    // request params
    var url = "https://gateway.bepaid.by/transactions/authorizations"
    var request = "request"
    var amount = "amount"
    var currency = "currency"
    var descriptionParams = "description"
    var description = "Apple Pay Test"
    var trackingIdParams = "tracking_id"
    var trackingId = "Apple Pay test transaction"
    var test = "test"
    var testStatus = true
    var creditCard = "credit_card"
    var token = "token"
    var begatewayApplePay = "$begateway_apple_pay_1_0_0$"
    var paymentData = "paymentData"
    
    var httpRequestMethod = "POST"
    var applicationJSON = "application/json"
    var contentType = "Content-Type"
    var accept = "Accept"
    var authorization = "Authorization"
    
    // options
    var shopId = "18945"
    var shopKey = "698df9920b62d11e8fefd8b3d0c7257f723de2af879bc88b093b47cefe1280b3"
    var merchantId = "merchant.org.cocoapods.demo.begateway-Example"
    
    var successfulTransaction = "successful"
    var failureStatus = "failure"
    
}
