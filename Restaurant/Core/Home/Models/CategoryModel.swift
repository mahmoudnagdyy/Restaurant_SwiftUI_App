//
//  CategoryModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 21/01/2026.
//

import Foundation

struct CategoryModel: Codable, Identifiable, Hashable {
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let name: String
    let image: CategoryImage
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", name, image
    }
}


struct CategoryImage: Codable, Hashable {
    let public_id: String
    let secure_url: String
}

struct CategoryResponseModel: Codable {
    let message: String
    let categories: [CategoryModel]?
    let validationErrors: [String]?
    let category: CategoryModel?
}
