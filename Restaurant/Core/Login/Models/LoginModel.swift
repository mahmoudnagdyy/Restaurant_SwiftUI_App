//
//  LoginModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import Foundation


struct LoginModel: Codable {
    let email: String
    let password: String
}


struct LoginResponseModel: Codable {
    let message: String
    let token: String?
    let validationErrors: [String]?
}
