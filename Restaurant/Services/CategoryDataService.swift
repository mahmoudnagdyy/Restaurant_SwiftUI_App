//
//  CategoryDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 21/01/2026.
//

import Foundation
internal import Combine
import UIKit


class CategoryDataService {
    
    @Published var message: String = ""
    @Published var categories: [CategoryModel]?
    @Published var validationErrors: [String]?
        
    var cancellables = Set<AnyCancellable>()
    
    let imageService = ImageDataService()
    
    init() {
        getAllCategories()
    }
    
    func getAllCategories() {
        if let categories = CategoryCoreData.instance.getAllCategoriesFromCoreData(),
           categories.count > 0{
            self.categories = categories
        }
        else{
            getCategories()
        }
    }
    
    func addCategory(name: String, imageData: Data) {
        print("add category Function")
        guard let url = URL(string: "http://localhost:5050/category") else { return }
        
        // set request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("marmoush__\(token)", forHTTPHeaderField: "Authorization")

        var body = Data()

        // 🔹 NAME (Text Part)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(name)\r\n".data(using: .utf8)!)

        // 🔹 IMAGE (File Part)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // 🔹 END
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        
        // send request
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CategoryResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] CategoryResponseModel in
                guard let self else { return }
                self.message = CategoryResponseModel.message
                self.validationErrors = CategoryResponseModel.validationErrors
                if CategoryResponseModel.message == "Category created successfully" {
                    getCategories()
                }
            }
            .store(in: &cancellables)
    }
    
    func getCategories() {
        print("get categories from api")
        guard let url = URL(string: "http://localhost:5050/category") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("marmoush__\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [CategoryModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] categories in
                guard let self else { return }
                self.categories = categories
                
                if (CategoryCoreData.instance.getAllCategoriesFromCoreData()?.count ?? 0) < categories.count {
                    let filteredCategories = categories.filter { category in
                        return CategoryCoreData.instance.getAllCategoriesFromCoreData()?.contains(where: { $0.id == category.id }) == false
                    }
                    
                    for category in filteredCategories {
                        CategoryCoreData.instance.addCategoryToCoreData(category: category)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func deleteCategory(categoryId: String) {
        print("delete category from api")
        guard let url = URL(string: "http://localhost:5050/category/\(categoryId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("marmoush__\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CategoryResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] CategoryResponseModel in
                guard let self else { return }
                self.message = CategoryResponseModel.message
                print(CategoryResponseModel.message)
                if CategoryResponseModel.message == "Category deleted successfully" {
                    CategoryCoreData.instance.deleteCategoryFromCoreData(categoryId: categoryId)
                    getCategories()
                }
            }
            .store(in: &cancellables)

    }
    
}
