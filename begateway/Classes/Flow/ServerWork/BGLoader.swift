//
//  BGLoader.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

enum BGCheckoutTokenResult {
    case success(token: String, brands: [BGBrand])
    case error(Error)
}
enum BGPayResult {
    case success(BGPaymentResponseObject)
    case error(Error)
    case need3dSec(URL)
    case incomplete
    case failure(String)
}

class BGLoader {
    static func checkStatus(url: URL, publicKey: String, paymentToken: String, _ callback: @escaping (_ result: BGPaymentsResponseStatus) -> Void) {
        var request = URLRequest(url: url)
        request.setValue(publicKey, forHTTPHeaderField: "Authorization")
        request.setValue("2", forHTTPHeaderField: "X-Api-Version")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                callback(.error)
                return
            }
            guard let data = data else {
                callback(.error)
                return
            }
            do {
                let status = try JSONDecoder().decode(BGStatusListenerResponse.self, from: data).checkout.status
                if status == .failed || status == .successful {
                    callback(status)
                } else {
                    callback(.incomplete)
                }
            } catch {
                callback(.error)
            }
        }
        task.resume()
    }
    
    static func pay(paymentToken: String, url: URL, publicKey: String, tokenizedCard: BGTokenizedCard, _ callback: @escaping (_ result: BGPayResult)->Void) {
        var request = URLRequest(url: url)
        request.setValue(publicKey, forHTTPHeaderField: "Authorization")
        request.setValue("2", forHTTPHeaderField: "X-Api-Version")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let payment = BGTokenizedCardPayment(
                paymentToken: paymentToken,
                tokenizedCard: tokenizedCard)
            let paymentReq = BGTokenizedCardPaymentRequest(request: payment)
            let reqData = try encoder.encode(paymentReq)
            
            request.httpBody = reqData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    callback(.error(error))
                    return
                }
                guard let data = data else {
                    callback(.error(BGErrors.endpointNotValid))
                    return
                }
                do {
                    let paymentResponse = try JSONDecoder().decode(BGPaymentResponse.self, from: data).response
                    switch paymentResponse.status {
                    case .error, .failed:
                        callback(.failure(paymentResponse.message ?? ""))
                    case .incomplete:
                        guard let threeDSecURL = URL(string: paymentResponse.threeDSecureVerification?.url ?? "") else {
                            callback(.incomplete)
                            return
                        }
                        callback(.need3dSec(threeDSecURL))
                    case .successful:
                        callback(.success(paymentResponse))
                    }
                } catch let errorRes {
                    callback(.error(errorRes))
                }
            }
            task.resume()
        } catch let error {
            callback(.error(error))
        }
    }
    
    static func pay(paymentToken: String, url: URL, publicKey: String, card: BGCard, customer: BGCustomer?, paymentMethod: BGPaymentMethod, _ callback: @escaping (_ result: BGPayResult)->Void) {
        var request = URLRequest(url: url)
        request.setValue(publicKey, forHTTPHeaderField: "Authorization")
        request.setValue("2", forHTTPHeaderField: "X-Api-Version")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let payment = BGPayment(
                customer: nil,
                paymentMethod: .creditCard,
                token: paymentToken,
                creditCard: card)
            let paymentReq = BGPaymentRequest(request: payment)
            let reqData = try encoder.encode(paymentReq)
            
            request.httpBody = reqData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    callback(.error(error))
                    return
                }
                guard let data = data else {
                    callback(.error(BGErrors.endpointNotValid))
                    return
                }
                do {
                    let paymentResponse = try JSONDecoder().decode(BGPaymentResponse.self, from: data).response
                    switch paymentResponse.status {
                    case .error, .failed:
                        callback(.failure(paymentResponse.message ?? ""))
                    case .incomplete:
                        guard let threeDSecURL = URL(string: paymentResponse.threeDSecureVerification?.url ?? "") else {
                            callback(.incomplete)
                            return
                        }
                        callback(.need3dSec(threeDSecURL))
                    case .successful:
                        callback(.success(paymentResponse))
                    }
                } catch let errorRes {
                    callback(.error(errorRes))
                }
            }
            task.resume()
        } catch let error {
            callback(.error(error))
        }
    }
    static func checkoutToken(settings: BGPaymentSettings,
                              transactionType: BGTransactionType,
                              checkoutURL: URL,
                              publicKey: String,
                              order: BGOrder,
                              _ callback: @escaping (_ result: BGCheckoutTokenResult)->Void) {
        var request = URLRequest(url: checkoutURL)
        request.setValue(publicKey, forHTTPHeaderField: "Authorization")
        request.setValue("2", forHTTPHeaderField: "X-Api-Version")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let ckeckoutSettings = BGCheckoutSettings(
                language: settings.locale,
                returnUrl: settings.returnURL,
                notificationUrl: settings.notificationURL,
                autoReturn: true)
            
            let checkout = BGCheckout(
                iframe: nil,
                test: settings.isTestMode,
                transactionType: transactionType,
                attempts: nil,
                publicKey: nil,
                order: order,
                customer: nil,
                settings: ckeckoutSettings)
            let checkoutReq = BGCheckoutRequest(checkout: checkout)
            let reqdata = try encoder.encode(checkoutReq)
            
            request.httpBody = reqdata
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    callback(.error(error))
                    return
                }
                guard let data = data else {
                    callback(.error(BGErrors.noCheckoutResponseData))
                    return
                }
                do {
                    let checkOutResponse = try JSONDecoder().decode(BGCheckoutResponse.self, from: data)
                    callback(.success(token: checkOutResponse.checkout.token, brands: checkOutResponse.checkout.brands ?? []))
                } catch let errorRes {
                    callback(.error(errorRes))
                }
            }
            task.resume()
        } catch let error {
            callback(.error(error))
        }
    }
}
