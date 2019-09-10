//
//  BG3dSecVerificationObject.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation

struct BG3dSecVerificationObject: Codable {
    var status: BGPaymentsResponseStatus
    var message: String?
    var failReason: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case failReason = "fail_reason"
        case url = "pa_res_url"
    }
}
