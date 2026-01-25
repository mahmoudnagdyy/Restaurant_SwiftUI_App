//
//  CartDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 23/01/2026.
//

import Foundation
internal import Combine


class CartDataService {
    
    @Published var message: String?
    @Published var cart: CartModel?
    
    var cancellables = Set<AnyCancellable>()
        
    init() {
//        getCart()
        
        ContentViewViewModel.instance.isServerReachable()
        
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: "isOn") == true {
                print(UserDefaults.standard.bool(forKey: "isOn"))
                print("cart from api")
                UserDefaults.standard.set(false, forKey: "isOn")
                self.getCart()
                
            }
            else{
                print(UserDefaults.standard.bool(forKey: "isOn"))
                print("cart from core data")
                self.getUserCart()
            }
        }
        
    }
    
    private func getUserCart() {
        let userId = UserDefaults.standard.string(forKey: "loggedInUserId") ?? ""
        if let cart = CartCoreData.instanse.getCartFromCoreData(userId: userId),
           cart.items.count > 0{
            self.cart = cart
        }
        else{
            getCart()
        }
    }
    
    func addToCart(product: ProductModel) {
        print("Add to cart api")
        guard let url = URL(string: "http://localhost:5050/cart/\(product.id)") else {
            print("wrong url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
            .decode(type: CartResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in 
                print(completion)
            } receiveValue: { [weak self] CartResponseModel in
                guard let self else { return }
                self.message = CartResponseModel.message
                print(CartResponseModel.message)
                if CartResponseModel.message == "Add to cart" || CartResponseModel.message == "quantity Added" || CartResponseModel.message == "Added to cart" {
                    print("cart is done")
                    getCart()
                }
            }
            .store(in: &cancellables)
    }
    
    func getCart() {
        print("Get cart api")
        guard let url = URL(string: "http://localhost:5050/cart") else {
            print("get cart url is not valid")
            return
        }
        
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
            .decode(type: CartResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] CartResponseModel in
                guard let self else { return }
                self.cart = CartResponseModel.cart
                self.message = CartResponseModel.message
                
                print(CartResponseModel.message)
                print(CartResponseModel.cart ?? "no cart")
                
                if let cart = CartResponseModel.cart {
                    print("cart from api")
                    print(cart)
                    CartCoreData.instanse.addCartToCoreData(userId: cart.user, items: cart.items, totalPrice: cart.totalPrice)
                }
            }
            .store(in: &cancellables)
    }
    
    func updateCart(cartId: String, productId: String, quantity: Int) {
        guard let url = URL(string: "http://localhost:5050/cart/\(cartId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("marmoush__\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(updateCartModel(productId: productId, quantity: quantity))
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CartResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] CartResponseModel in
                guard let self else { return }
                self.message = CartResponseModel.message
                if CartResponseModel.message == "quantity updated" {
                    getCart()
                }
                else if CartResponseModel.message == "item deleted from cart" {
                    getCart()
                }
            }
            .store(in: &cancellables)

    }
    
}
