

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class Welcome: Codable {
    let transaction: Transaction

    init(transaction: Transaction) {
        self.transaction = transaction
    }
}

// MARK: - Transaction
class Transaction: Codable {
    let uid, status: String
    let amount: Int
    let currency, transactionDescription, type, paymentMethodType: String
    let trackingID, message: String
    let test: Bool
    let createdAt, updatedAt, paidAt: String
    let expiredAt, recurringType, closedAt, settledAt: JSONNull?
    let manuallyCorrectedAt: JSONNull?
    let language: String
    let creditCard: CreditCard
    let receiptURL: String
    let statusCode: JSONNull?
    let id: String
    let redirectURL: String
    let beProtectedVerification: BeProtectedVerification
    let threeDSecureVerification: ThreeDSecureVerification
    let authorization: Authorization
    let avsCvcVerification: AvsCvcVerification
    let customer: Customer
    let billingAddress: BillingAddress

    enum CodingKeys: String, CodingKey {
        case uid, status, amount, currency
        case transactionDescription = "description"
        case type
        case paymentMethodType = "payment_method_type"
        case trackingID = "tracking_id"
        case message, test
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case paidAt = "paid_at"
        case expiredAt = "expired_at"
        case recurringType = "recurring_type"
        case closedAt = "closed_at"
        case settledAt = "settled_at"
        case manuallyCorrectedAt = "manually_corrected_at"
        case language
        case creditCard = "credit_card"
        case receiptURL = "receipt_url"
        case statusCode = "status_code"
        case id
        case redirectURL = "redirect_url"
        case beProtectedVerification = "be_protected_verification"
        case threeDSecureVerification = "three_d_secure_verification"
        case authorization
        case avsCvcVerification = "avs_cvc_verification"
        case customer
        case billingAddress = "billing_address"
    }

    init(uid: String, status: String, amount: Int, currency: String, transactionDescription: String, type: String, paymentMethodType: String, trackingID: String, message: String, test: Bool, createdAt: String, updatedAt: String, paidAt: String, expiredAt: JSONNull?, recurringType: JSONNull?, closedAt: JSONNull?, settledAt: JSONNull?, manuallyCorrectedAt: JSONNull?, language: String, creditCard: CreditCard, receiptURL: String, statusCode: JSONNull?, id: String, redirectURL: String, beProtectedVerification: BeProtectedVerification, threeDSecureVerification: ThreeDSecureVerification, authorization: Authorization, avsCvcVerification: AvsCvcVerification, customer: Customer, billingAddress: BillingAddress) {
        self.uid = uid
        self.status = status
        self.amount = amount
        self.currency = currency
        self.transactionDescription = transactionDescription
        self.type = type
        self.paymentMethodType = paymentMethodType
        self.trackingID = trackingID
        self.message = message
        self.test = test
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.paidAt = paidAt
        self.expiredAt = expiredAt
        self.recurringType = recurringType
        self.closedAt = closedAt
        self.settledAt = settledAt
        self.manuallyCorrectedAt = manuallyCorrectedAt
        self.language = language
        self.creditCard = creditCard
        self.receiptURL = receiptURL
        self.statusCode = statusCode
        self.id = id
        self.redirectURL = redirectURL
        self.beProtectedVerification = beProtectedVerification
        self.threeDSecureVerification = threeDSecureVerification
        self.authorization = authorization
        self.avsCvcVerification = avsCvcVerification
        self.customer = customer
        self.billingAddress = billingAddress
    }
}

// MARK: - Authorization
class Authorization: Codable {
    let authCode, bankCode, rrn, refID: String
    let message: String
    let amount: Int
    let currency, billingDescriptor: String
    let gatewayID: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case authCode = "auth_code"
        case bankCode = "bank_code"
        case rrn
        case refID = "ref_id"
        case message, amount, currency
        case billingDescriptor = "billing_descriptor"
        case gatewayID = "gateway_id"
        case status
    }

    init(authCode: String, bankCode: String, rrn: String, refID: String, message: String, amount: Int, currency: String, billingDescriptor: String, gatewayID: Int, status: String) {
        self.authCode = authCode
        self.bankCode = bankCode
        self.rrn = rrn
        self.refID = refID
        self.message = message
        self.amount = amount
        self.currency = currency
        self.billingDescriptor = billingDescriptor
        self.gatewayID = gatewayID
        self.status = status
    }
}

// MARK: - AvsCvcVerification
class AvsCvcVerification: Codable {
    let avsVerification, cvcVerification: Verification

    enum CodingKeys: String, CodingKey {
        case avsVerification = "avs_verification"
        case cvcVerification = "cvc_verification"
    }

    init(avsVerification: Verification, cvcVerification: Verification) {
        self.avsVerification = avsVerification
        self.cvcVerification = cvcVerification
    }
}

// MARK: - Verification
class Verification: Codable {
    let resultCode: String

    enum CodingKeys: String, CodingKey {
        case resultCode = "result_code"
    }

    init(resultCode: String) {
        self.resultCode = resultCode
    }
}

// MARK: - BeProtectedVerification
class BeProtectedVerification: Codable {
    let status: String
    let message: JSONNull?
    let whiteBlackList: WhiteBlackList
    let rules: Rules

    enum CodingKeys: String, CodingKey {
        case status, message
        case whiteBlackList = "white_black_list"
        case rules
    }

    init(status: String, message: JSONNull?, whiteBlackList: WhiteBlackList, rules: Rules) {
        self.status = status
        self.message = message
        self.whiteBlackList = whiteBlackList
        self.rules = rules
    }
}

// MARK: - Rules
class Rules: Codable {
    let the9_11165_AppleTest, the9_Apple: The9_11165__AppleTest
    let bePaid: BePaid

    enum CodingKeys: String, CodingKey {
        case the9_11165_AppleTest = "9_11165_apple-test"
        case the9_Apple = "9_Apple"
        case bePaid
    }

    init(the9_11165_AppleTest: The9_11165__AppleTest, the9_Apple: The9_11165__AppleTest, bePaid: BePaid) {
        self.the9_11165_AppleTest = the9_11165_AppleTest
        self.the9_Apple = the9_Apple
        self.bePaid = bePaid
    }
}

// MARK: - BePaid
class BePaid: Codable {
    let highRiskBINAlert: HighRiskBINAlert
    let fraudsters: Fraudsters
    let alertIfTooManyAttempts: AlertIfTooManyAttempts

    enum CodingKeys: String, CodingKey {
        case highRiskBINAlert = "HighRiskBIN_Alert"
        case fraudsters = "Fraudsters"
        case alertIfTooManyAttempts = "Alert if too many attempts"
    }

    init(highRiskBINAlert: HighRiskBINAlert, fraudsters: Fraudsters, alertIfTooManyAttempts: AlertIfTooManyAttempts) {
        self.highRiskBINAlert = highRiskBINAlert
        self.fraudsters = fraudsters
        self.alertIfTooManyAttempts = alertIfTooManyAttempts
    }
}

// MARK: - AlertIfTooManyAttempts
class AlertIfTooManyAttempts: Codable {
    let totalFailedPaymentTransactionsCountMoreThan500PerIPAddressIn24HoursANDBINCountryIsNotInBelarus: String

    enum CodingKeys: String, CodingKey {
        case totalFailedPaymentTransactionsCountMoreThan500PerIPAddressIn24HoursANDBINCountryIsNotInBelarus = "Total failed payment transactions count more than 5.00 per IP address in 24 hours AND BIN country is not in Belarus"
    }

    init(totalFailedPaymentTransactionsCountMoreThan500PerIPAddressIn24HoursANDBINCountryIsNotInBelarus: String) {
        self.totalFailedPaymentTransactionsCountMoreThan500PerIPAddressIn24HoursANDBINCountryIsNotInBelarus = totalFailedPaymentTransactionsCountMoreThan500PerIPAddressIn24HoursANDBINCountryIsNotInBelarus
    }
}

// MARK: - Fraudsters
class Fraudsters: Codable {
    let panNameIsInFraudsters: String

    enum CodingKeys: String, CodingKey {
        case panNameIsInFraudsters = "PAN name is in Fraudsters"
    }

    init(panNameIsInFraudsters: String) {
        self.panNameIsInFraudsters = panNameIsInFraudsters
    }
}

// MARK: - HighRiskBINAlert
class HighRiskBINAlert: Codable {
    let binIsInHighRiskBINS: String

    enum CodingKeys: String, CodingKey {
        case binIsInHighRiskBINS = "BIN is in HighRisk_BINs"
    }

    init(binIsInHighRiskBINS: String) {
        self.binIsInHighRiskBINS = binIsInHighRiskBINS
    }
}

// MARK: - The9_11165__AppleTest
class The9_11165__AppleTest: Codable {

    init() {
    }
}

// MARK: - WhiteBlackList
class WhiteBlackList: Codable {
    let email, ip, cardNumber: String

    enum CodingKeys: String, CodingKey {
        case email, ip
        case cardNumber = "card_number"
    }

    init(email: String, ip: String, cardNumber: String) {
        self.email = email
        self.ip = ip
        self.cardNumber = cardNumber
    }
}

// MARK: - BillingAddress
class BillingAddress: Codable {
    let firstName, lastName, address, country: JSONNull?
    let city, zip, state, phone: JSONNull?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case address, country, city, zip, state, phone
    }

    init(firstName: JSONNull?, lastName: JSONNull?, address: JSONNull?, country: JSONNull?, city: JSONNull?, zip: JSONNull?, state: JSONNull?, phone: JSONNull?) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.country = country
        self.city = city
        self.zip = zip
        self.state = state
        self.phone = phone
    }
}

// MARK: - CreditCard
class CreditCard: Codable {
    let holder: JSONNull?
    let stamp, brand, last4, first1: String
    let bin, issuerCountry, issuerName, product: String
    let expMonth, expYear: Int
    let tokenProvider: String
    let token: JSONNull?

    enum CodingKeys: String, CodingKey {
        case holder, stamp, brand
        case last4 = "last_4"
        case first1 = "first_1"
        case bin
        case issuerCountry = "issuer_country"
        case issuerName = "issuer_name"
        case product
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case tokenProvider = "token_provider"
        case token
    }

    init(holder: JSONNull?, stamp: String, brand: String, last4: String, first1: String, bin: String, issuerCountry: String, issuerName: String, product: String, expMonth: Int, expYear: Int, tokenProvider: String, token: JSONNull?) {
        self.holder = holder
        self.stamp = stamp
        self.brand = brand
        self.last4 = last4
        self.first1 = first1
        self.bin = bin
        self.issuerCountry = issuerCountry
        self.issuerName = issuerName
        self.product = product
        self.expMonth = expMonth
        self.expYear = expYear
        self.tokenProvider = tokenProvider
        self.token = token
    }
}

// MARK: - Customer
class Customer: Codable {
    let ip, email, deviceID, birthDate: JSONNull?

    enum CodingKeys: String, CodingKey {
        case ip, email
        case deviceID = "device_id"
        case birthDate = "birth_date"
    }

    init(ip: JSONNull?, email: JSONNull?, deviceID: JSONNull?, birthDate: JSONNull?) {
        self.ip = ip
        self.email = email
        self.deviceID = deviceID
        self.birthDate = birthDate
    }
}

// MARK: - ThreeDSecureVerification
class ThreeDSecureVerification: Codable {
    let status, message, veStatus: String
    let acsURL, paReq, md: JSONNull?
    let paResURL: String
    let eci, paStatus, xid, cavv: String
    let cavvAlgorithm, failReason, methodProcessURL, creq: JSONNull?

    enum CodingKeys: String, CodingKey {
        case status, message
        case veStatus = "ve_status"
        case acsURL = "acs_url"
        case paReq = "pa_req"
        case md
        case paResURL = "pa_res_url"
        case eci
        case paStatus = "pa_status"
        case xid, cavv
        case cavvAlgorithm = "cavv_algorithm"
        case failReason = "fail_reason"
        case methodProcessURL = "method_process_url"
        case creq
    }

    init(status: String, message: String, veStatus: String, acsURL: JSONNull?, paReq: JSONNull?, md: JSONNull?, paResURL: String, eci: String, paStatus: String, xid: String, cavv: String, cavvAlgorithm: JSONNull?, failReason: JSONNull?, methodProcessURL: JSONNull?, creq: JSONNull?) {
        self.status = status
        self.message = message
        self.veStatus = veStatus
        self.acsURL = acsURL
        self.paReq = paReq
        self.md = md
        self.paResURL = paResURL
        self.eci = eci
        self.paStatus = paStatus
        self.xid = xid
        self.cavv = cavv
        self.cavvAlgorithm = cavvAlgorithm
        self.failReason = failReason
        self.methodProcessURL = methodProcessURL
        self.creq = creq
    }
}



