//
//  BeGatewayRequestCustomer.swift
//  begateway
//
//  Created by Alexey Kostenko on 7.07.25.
//

import Foundation

public struct BeGatewayRequestCustomer {
    
    public let address, country, city, email, firstName, lastName, state, zip, phone, birthDate: String?
    
    public init(address: String?, country: String?, city: String?, email: String?, firstName: String?, lastName: String?, state: String?, zip: String?, phone: String?, birthDate: String?) {
        self.address = address
        self.country = country
        self.city = city
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.state = state
        self.zip = zip
        self.phone = phone
        self.birthDate = birthDate
    }
}
