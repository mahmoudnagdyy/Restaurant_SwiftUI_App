//
//  VerifyModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import Foundation

struct VerifyModel: Codable {
    let userId: String
    let verificationCode: String
}

struct VerifyResponse: Codable {
    let message: String
    let validationErrors: [String]?
}
