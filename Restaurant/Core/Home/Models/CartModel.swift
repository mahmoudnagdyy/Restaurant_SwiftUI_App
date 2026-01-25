//
//  CartModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 23/01/2026.
//

import Foundation


struct CartModel: Codable, Identifiable {
    let id: String
    let items: [CartItem]
    let totalPrice: Double
    let user: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", items, totalPrice, user
    }
}


struct CartItem: Codable, Identifiable{
    let id: String
    let product: ProductModel
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", product, quantity
    }
}

struct CartResponseModel: Codable{
    let message: String
    let cart: CartModel?
}

struct updateCartModel: Codable{
    let productId: String
    let quantity: Int
}
