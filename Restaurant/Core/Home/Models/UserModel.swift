//
//  UserModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let password: String
    let phone: String
    let role: String
    let profileImage: UserImage?
    let isVerified: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", name, email, password, phone, role, profileImage, isVerified
    }
    
}

struct UserImage: Codable {
    let public_id: String
    let secure_url: String
}


struct UserResponseModel: Codable {
    let user: UserModel?
    let message: String
}
