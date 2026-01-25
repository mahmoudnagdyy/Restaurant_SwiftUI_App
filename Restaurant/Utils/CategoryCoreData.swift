//
//  CategoryCoreData.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 24/01/2026.
//

import Foundation
import CoreData

class CategoryCoreData {
    
    static let instance = CategoryCoreData()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = CoreDataManager.instance.container
        context = CoreDataManager.instance.context
    }
    
    func addCategoryToCoreData(category: CategoryModel) {
        print("add category to CoreData")
        let newCategory = CategoryEntity(context: context)
        newCategory.name = category.name
        newCategory.id = category.id
        let image = CategoryImageEntity(context: context)
        image.public_id = category.image.public_id
        image.secure_url = category.image.secure_url
        newCategory.image = image
        save()
    }
    
    func getAllCategoriesFromCoreData() -> [CategoryModel]? {
        print("get all categories from CoreData")
        let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        
        do {
            let categories = try context.fetch(request)
            return categories.map { category in
                return CategoryModel(id: category.id ?? "", name: category.name ?? "", image: CategoryImage(public_id: category.image?.public_id ?? "", secure_url: category.image?.secure_url ?? ""))
            }
            
        } catch {
            print("Error fetching categories from CoreData: \(error)")
        }
        
        return nil
    }
    
    func deleteCategoryFromCoreData(categoryId: String) {
        print("delete category from CoreData")
        let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        request.predicate = NSPredicate(format: "id == %@", categoryId)
        
        do {
            let category = try context.fetch(request).first
            if let category {
                context.delete(category)
                print("category deleted.")
            }
            save()
        } catch  {
            print("Error fetching category from CoreData: \(error)")
        }
        
    }
    
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Error saving category to CoreData: \(error)")
        }
    }
    
}
