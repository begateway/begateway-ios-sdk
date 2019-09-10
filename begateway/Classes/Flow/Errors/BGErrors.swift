//
//  BGErrors.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation


public enum BGErrors: Error {
    case endpointNotValid
    case noOrderSet
    case noStoreKeySet
    case noCheckoutResponseData
    case noPaymentResponseData
    case noPaymentToken
    case cantCheckOperationStatus
}

extension BGErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .endpointNotValid:
            return "Cannot convert endpoint. Please set valid URL string to endpoint field in settings of payment module"
        case .noOrderSet:
            return "Please, set order to make payment"
        case .noStoreKeySet:
            return "Please, set store key to make payment"
        case .noCheckoutResponseData:
            return "Checkout request return invalid data"
        case .noPaymentResponseData:
            return "Payment request return invalid data"
        case .noPaymentToken:
            return "Not find payment token to make pay or it empty"
        case .cantCheckOperationStatus:
            return "Cannot check operation status. It can be Success or failed."
        }
    }
}
