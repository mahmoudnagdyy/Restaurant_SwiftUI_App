//
//  HomeViewModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import Foundation
internal import Combine
import _PhotosUI_SwiftUI
import SwiftUI


class HomeViewModel: ObservableObject {
    
    @Published var user: UserModel? = nil
    @Published var searchText: String = ""
    @Published var selectedUserImage: PhotosPickerItem?
    @Published var profileImage: UIImage? = nil
    
    @Published var isLoading: Bool = false
    
    @Published var showCategoriesSheet: Bool = false
    @Published var showProductsSheet: Bool = false
    
    // category
    @Published var categoryName: String = ""
    @Published var selectedCategoryImage: PhotosPickerItem?
    @Published var addCategoryImage: UIImage? = nil
    @Published var categoryMessage: String?
    @Published var categories: [CategoryModel] = []
    @Published var categoryValidationErrors: [String]?
    @Published var isAddingCategory: Bool = false
        
    // product
    @Published var productName: String = ""
    @Published var selectedProductImage: PhotosPickerItem? = nil
    @Published var addProductImage: UIImage? = nil
    @Published var productPrice : String = ""
    @Published var productDiscription : String = ""
    @Published var productMessage: String?
    @Published var productValidationErrors: [String]?
    @Published var isAddingProduct: Bool = false
    @Published var products: [ProductModel] = []
    
    
    // cart
    @Published var cartMessage: String?
    @Published var cart: CartModel? = nil
    
    
    private let userService = UserDataService()
    private let categoryService = CategoryDataService()
    private let productService = ProductDataService()
    private let cartService = CartDataService()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        // ------------ user ------------
        userService.$user
            .sink { [weak self] user in
                guard let self else { return }
                self.user = user
            }
            .store(in: &cancellables)
        
        userService.$profileImage
            .sink { [weak self] img in
                guard let self else { return }
                self.profileImage = img
            }
            .store(in: &cancellables)
        
        userService.$isLoading
            .sink { [weak self] value in
                self?.isLoading = value
            }
            .store(in: &cancellables)
        
        $selectedUserImage
            .sink { [weak self] pickedImage in
                guard let self else { return }
                Task {
                    let imageData = try? await pickedImage?.loadTransferable(type: Data.self)
                    if let imageData {
                        self.userService.uploadPhoto(imageData: imageData, imageName: self.user?.id ?? "")
                    }
                }
            }
            .store(in: &cancellables)
        
        // ------------ category ------------
        categoryService.$message
            .combineLatest(categoryService.$categories, categoryService.$validationErrors)
            .sink { [weak self] msg, categories, ValidationErrors in
                guard let self else { return }
                isAddingCategory = false
                if msg == "Category created successfully" {
                    showCategoriesSheet.toggle()
                    selectedCategoryImage = nil
                    addCategoryImage = nil
                    categoryName = ""
                }
                else if msg == "Validation Error" {
                    self.categoryValidationErrors = ValidationErrors
                }
                else if msg == "Category deleted successfully" {
                    cartService.getCart()
                }
                self.categoryMessage = msg
            }
            .store(in: &cancellables)
        
        $selectedCategoryImage
            .sink { [weak self] img in
                guard let self else { return }
                Task{
                    let imageData = try? await img?.loadTransferable(type: Data.self)
                    if let imageData {
                        self.addCategoryImage = UIImage(data: imageData)
                    }
                }
            }
            .store(in: &cancellables)
        
        categoryService.$categories
            .sink { [weak self] categories in
                guard let self else { return }
                if let categories {
                    self.categories = categories
                }
            }
            .store(in: &cancellables)
        
        // ----------- product ------------
        $selectedProductImage
            .sink { [weak self] img in
                guard let self else { return }
                Task {
                    let imageData = try? await img?.loadTransferable(type: Data.self)
                    if let imageData {
                        self.addProductImage = UIImage(data: imageData)
                    }
                }
            }
            .store(in: &cancellables)
        
        productService.$message
            .combineLatest(productService.$validationErrors)
            .sink { [weak self] msg, validationErrors in
                guard let self else { return }
                if msg != "Validation Error" {
                    self.productMessage = msg
                }
                self.productValidationErrors = validationErrors
                isAddingProduct = false
                if msg == "product created successfully" {
                    showProductsSheet.toggle()
                }
            }
            .store(in: &cancellables)
        
        productService.$products
            .sink { [weak self] products in
                guard let self else { return }
                self.products = products
            }
            .store(in: &cancellables)
        
        // ------------ cart ------------
        cartService.$message
            .combineLatest(cartService.$cart)
            .sink { [weak self] message, cart in
                guard let self else { return }
                self.cart = cart
            }
            .store(in: &cancellables)
    }
    
    func addCategory() async {
        isAddingCategory = true
        let imageData = try? await selectedCategoryImage?.loadTransferable(type: Data.self)
        if let imageData {
            categoryService.addCategory(name: categoryName, imageData: imageData)
        }
    }
    
    func deleteCategory(categoryId: String) {
        categoryService.deleteCategory(categoryId: categoryId)
    }
    
    func addProduct(categoryId: String) async {
        isAddingProduct = true
        let imageData = try? await selectedProductImage?.loadTransferable(type: Data.self)
        if let imageData {
            productService.addProduct(name: productName, description: productDiscription, price: Double(productPrice) ?? 0, categoryId: categoryId , imageData: imageData)
        }
        
        productName = ""
        productPrice = ""
        productDiscription = ""
        selectedProductImage = nil
        addProductImage = nil
    }
    
    func getAllProducts(categoryId: String) {
        productService.getAllProducts(categoryId: categoryId)
    }
    
    func AddToCart(product: ProductModel) {
        cartService.addToCart(product: product)
    }
    
    func updateCart(cartId: String, product: ProductModel, quantity: Int) {
        cartService.updateCart(cartId: cartId, productId: product.id, quantity: quantity)
    }
    
}
