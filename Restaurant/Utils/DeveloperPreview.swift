//
//  DeveloperPreview.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import Foundation

class DeveloperPreview {
    
    static let instanse = DeveloperPreview()
    
    let categoryPreview = CategoryModel(id: "6971231b9ff978041ce3b59c", name: "pizza",image: CategoryImage(public_id: "Restaurant/Categories/Oc3fn/xtihshy81mp7zgtf4y5n",secure_url: "https://res.cloudinary.com/ddbxrwwmz/image/upload/v1769022234/Restaurant/Categories/Oc3fn/xtihshy81mp7zgtf4y5n.jpg"))
    
    
    let userPreview = UserModel(id: "696f9154f2e8565327501c71", name: "mahmoud nagdy", email: "mahmoudnagdy65@gmail.com", password: "$2b$10$WLHNpdm4L8gNAFIxrZ4RVO7nmY3l3TAoKZKoyaTURQKpHPsGzkGhG", phone: "01069255958", role: "admin", profileImage: UserImage(public_id: "Restaurant/users/696f9154f2e8565327501c71/ifrvvapxqqo0dwsc64az", secure_url: "https://res.cloudinary.com/ddbxrwwmz/image/upload/v1769086819/Restaurant/users/696f9154f2e8565327501c71/ifrvvapxqqo0dwsc64az.jpg"), isVerified: true)
    
    let productPreview = ProductModel(id: "6972684e6a8879222ef1014f", name: "burger one", description: "hihi", price: 120, image: ProductImage(public_id: "Restaurant/Categories/IkdUj/products/haE4W/any5lu9dwd52rlsv0bbz", secure_url: "https://res.cloudinary.com/ddbxrwwmz/image/upload/v1769105485/Restaurant/Categories/IkdUj/products/haE4W/any5lu9dwd52rlsv0bbz.jpg"), categoryId: "697123e6483dcf225b9e5fb4", isAvailable: true)
    
    let cartPreview = CartModel(id: "", items: [], totalPrice: 0, user: "")
    
}
