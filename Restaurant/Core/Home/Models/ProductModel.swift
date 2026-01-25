//
//  ProductModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import Foundation


struct ProductModel: Codable, Identifiable, Hashable {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id : String
    let name : String
    let description: String?
    let price : Double
    let image: ProductImage
    let categoryId : String
    let isAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case price
        case description
        case image
        case categoryId
        case isAvailable
    }
}

struct ProductImage: Codable, Hashable {
    let public_id: String
    let secure_url: String
}


struct ProductResponseModel: Codable {
    let message: String
    let validationErrors: [String]?
}
