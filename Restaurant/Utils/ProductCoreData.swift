//
//  ProductCoreData.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 24/01/2026.
//

import Foundation
import CoreData


class ProductCoreData {
    
    static let instance = ProductCoreData()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = CoreDataManager.instance.container
        context = CoreDataManager.instance.context
    }
    
    
    func addProductToCoreData(product: ProductModel) {
        print("Add product to CoreData")
        // category
        let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        request.predicate = NSPredicate(format: "id == %@", product.categoryId)
        var category: CategoryEntity?
        do {
            category = try context.fetch(request).first
        } catch {
            print("Error fetching category from CoreData")
        }
        
        print(product)
        print("product from addProductToCoreData")
        
        // product
        let newProduct = ProductEntity(context: context)
        newProduct.id = product.id
        newProduct.name = product.name
        newProduct.price = Double(product.price)
        newProduct.desc = product.description
        newProduct.isAvailable = product.isAvailable
        newProduct.category = category
        let image = ProductImageEntity(context: context)
        image.public_id = product.image.public_id
        image.secure_url = product.image.secure_url
        newProduct.image = image
        
        print(newProduct)
        save()
    }
    
    func getAllProductsFromCoreData(categoryId: String) -> [ProductModel]? {
        print("Get all products from CoreData")
        let request = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
        request.predicate = NSPredicate(format: "category.id == %@", categoryId)
        
        do {
            let products = try context.fetch(request)
            return products.map { product in
                return ProductModel(id: product.id ?? "", name: product.name ?? "", description: product.desc ?? "", price: product.price, image: ProductImage(public_id: product.image?.public_id ?? "", secure_url: product.image?.secure_url ?? ""), categoryId: product.category?.id ?? "", isAvailable: product.isAvailable)
            }
            
        } catch {
            print("Error fetching products from CoreData")
        }
        
        return nil
    }
    
    private func save() {
        do {
            try context.save()
        } catch  {
            print("Error saving product to CoreData")
        }
    }
    
}
