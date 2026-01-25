//
//  SignupModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import Foundation


struct SignupModel: Codable {
    let name: String
    let email: String
    let password: String
    let phone: String
}

struct SignupResponseModel: Codable {
    let message: String
    let userId: String?
    let validationErrors: [String]?
}
