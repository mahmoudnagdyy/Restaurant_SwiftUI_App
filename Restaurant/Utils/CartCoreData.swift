//
//  CartCoreData.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 24/01/2026.
//

import Foundation
import CoreData


class CartCoreData {
    
    
    static let instanse = CartCoreData()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = CoreDataManager.instance.container
        context = CoreDataManager.instance.context
    }
    
    func addCartToCoreData(userId: String, items: [CartItem], totalPrice: Double) {
        print("Add Cart To Core Data")
        // cart exist
        let request = NSFetchRequest<CartEntity>(entityName: "CartEntity")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let cart = try context.fetch(request).first
            if let cart {
                
                let oldItems = cart.items as? Set<CartItemEntity> ?? []
                for item in oldItems {
                    context.delete(item)
                }
                
                for item in items {
                    let newItem = CartItemEntity(context: context)
                    
                    let productRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
                    productRequest.predicate = NSPredicate(format: "id == %@", item.product.id)
                    var product: ProductEntity?
                    
                    do {
                        product = try context.fetch(productRequest).first
                        if let product {
                            newItem.product = product
                            newItem.quantity = Int16(item.quantity)
                        }
                        else{
                            let newProduct = ProductEntity(context: context)
                            let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
                            request.predicate = NSPredicate(format: "id == %@", item.product.categoryId)
                            var category: CategoryEntity?
                            do {
                                category = try context.fetch(request).first
                            } catch  {
                                print("Error fetching category: \(error)")
                            }
                            newProduct.id = item.product.id
                            newProduct.name = item.product.name
                            newProduct.desc = item.product.description
                            newProduct.price = item.product.price
                            newProduct.isAvailable = item.product.isAvailable
                            newProduct.category = category
                            
                            newItem.product = newProduct
                            newItem.quantity = Int16(item.quantity)
                            newItem.id = item.id
                        }
                    } catch {
                        print("Error fetching product: \(error)")
                    }
                    cart.addToItems(newItem)
                }
                
                cart.totalPrice = totalPrice
            }
            else{
                let cart = CartEntity(context: context)
                cart.userId = userId
                cart.totalPrice = totalPrice
                
                for item in items {
                    let newItem = CartItemEntity(context: context)
                    let productRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
                    productRequest.predicate = NSPredicate(format: "id == %@", item.product.id)
                    var product: ProductEntity?
                    
                    do {
                        product = try context.fetch(productRequest).first
                        if let product {
                            newItem.product = product
                            newItem.quantity = Int16(item.quantity)
                        }
                        else{
                            let newProduct = ProductEntity(context: context)
                            let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
                            request.predicate = NSPredicate(format: "id == %@", item.product.categoryId)
                            var category: CategoryEntity?
                            do {
                                category = try context.fetch(request).first
                            } catch  {
                                print("Error fetching category: \(error)")
                            }
                            newProduct.id = item.product.id
                            newProduct.name = item.product.name
                            newProduct.desc = item.product.description
                            newProduct.price = item.product.price
                            newProduct.isAvailable = item.product.isAvailable
                            newProduct.category = category
                            
                            newItem.product = newProduct
                            newItem.quantity = Int16(item.quantity)
                            newItem.id = item.id
                        }
                    } catch {
                        print("Error fetching product: \(error)")
                    }
                    
                    cart.addToItems(newItem)
                }
            }
            
            save()
            
        } catch  {
            print("Error fetching cart: \(error)")
        }
    }
    
    
    func getCartFromCoreData(userId: String) -> CartModel? {
        print("Get cart from Core Data")
        let request = NSFetchRequest<CartEntity>(entityName: "CartEntity")
        request.predicate = NSPredicate(format: "userId == %@", userId)
    
        do {
            let cart = try context.fetch(request).first
            if let cart {
                var items: [CartItem] = []
                let cartItems = cart.items as? Set<CartItemEntity> ?? []
                for item in cartItems {
                    let product = ProductModel(id: item.product?.id ?? "", name: item.product?.name ?? "", description: item.product?.desc, price: item.product?.price ?? 0, image: ProductImage(public_id: "", secure_url: ""), categoryId: item.product?.category?.id ?? "", isAvailable: item.product?.isAvailable ?? false)
                    items.append(CartItem(id: item.id ?? UUID().uuidString, product: product, quantity: Int(item.quantity)))
                }
                
                return CartModel(id: "", items: items, totalPrice: cart.totalPrice, user: userId)
            }
        } catch {
            print("Error fetching data from CoreData: \(error)")
        }
        
        return nil
    }
    
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
}
