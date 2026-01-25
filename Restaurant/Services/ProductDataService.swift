//
//  ProductDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import Foundation
internal import Combine


class ProductDataService {

    @Published var message: String = ""
    @Published var validationErrors: [String]? = nil
    @Published var products: [ProductModel] = []
    
    var cancellables = Set<AnyCancellable>()
    
    init() {

    }
    
    func getAllProducts(categoryId: String) {
        if let products = ProductCoreData.instance.getAllProductsFromCoreData(categoryId: categoryId),
           products.count > 0 {
            DispatchQueue.main.async {
                self.products = products
            }
            print(products)
        }
        else{
            getProducts(categoryId: categoryId)
        }
    }
    
    func addProduct(name: String, description: String, price: Double, categoryId: String, imageData: Data) {
        guard let url = URL(string: "http://localhost:5050/product") else { return }
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("marmoush__\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(name)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(description)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"price\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(price)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"categoryId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(categoryId)\r\n".data(using: .utf8)!)
    
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append(
            "Content-Disposition: form-data; name=\"image\"; filename=\"product.jpg\"\r\n"
            .data(using: .utf8)!
        )
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ProductResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] ProductResponseModel in
                guard let self else { return }
                self.message = ProductResponseModel.message
                self.validationErrors = ProductResponseModel.validationErrors
                if ProductResponseModel.message == "product created successfully" {
                    getProducts(categoryId: categoryId)
                    print("product added")
                }
            }
            .store(in: &cancellables)
    }
    
    func getProducts(categoryId: String) {
        guard let url = URL(string: "http://localhost:5050/product/\(categoryId)") else { return }
        
        print("get products from api")
                
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
            .decode(type: [ProductModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] products in
                guard let self else { return }
                self.products = products
                
                // core data
                if products.count > (ProductCoreData.instance.getAllProductsFromCoreData(categoryId: categoryId)?.count ?? 0) {
                    let filteredProducts = products.filter { product in
                        return ProductCoreData.instance.getAllProductsFromCoreData(categoryId: categoryId)?.contains(where: {$0.id == product.id }) == false
                    }
                    
                    for product in filteredProducts {
                        ProductCoreData.instance.addProductToCoreData(product: product)
                    }
                    
                }
                
            }
            .store(in: &cancellables)

    }
    
}
