//
//  CategoryProfileView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import SwiftUI

struct CategoryProfileView: View {
    
    let category: CategoryModel
    @StateObject var vm: CategoryViewModel
    @ObservedObject var homeVm: HomeViewModel
    
    @Environment(\.dismiss) var dismiss
    
    
    init(category: CategoryModel, homeVm: HomeViewModel) {
        self.category = category
        _vm = StateObject(wrappedValue: CategoryViewModel(category: category))
        self.homeVm = homeVm
    }
    
    var body: some View {
            ScrollView { // start: scrollview
                VStack { // start: vstack
                    
                    if let categoryImage = vm.categoryImage {
                        Image(uiImage: categoryImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    else{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 100)
                            .overlay(alignment: .center) {
                                ProgressView()
                                    .tint(.white)
                            }
                        
                    }
                    
                    if let user = homeVm.user,
                       user.role == "admin"{
                        ManageHeaderView(showSheet: $homeVm.showProductsSheet, text: "products")
                            .padding(.vertical, 30)
                            .sheet(isPresented: $homeVm.showProductsSheet) {
                                AddProductView(category: category, vm: homeVm)
                            }
                    }
                    else{
                        HomeHeaderTextView(text: "products")
                            .padding(.vertical, 30)
                    }
                                        
                    if homeVm.products.count > 0 {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 40) {
                                ForEach(homeVm.products) { product in
                                    NavigationLink(value: product) {
                                        ProductItemView(product: product) {
                                            homeVm.AddToCart(product: product)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .scrollIndicators(.hidden)
                    }
                    else{
                        Text("no products yet.".capitalized)
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.gray)
                    }
                     
                } // end: vstack
                .padding(.horizontal)
                .onAppear {
                    homeVm.getAllProducts(categoryId: category.id)
                }
            }// end: scrollview
            .navigationTitle(category.name.capitalized) 
            .toolbar { 
                ToolbarItem(placement: .topBarTrailing) {
                    if let user = homeVm.user,
                       user.role == "admin"{
                        Button {
                            homeVm.deleteCategory(categoryId: category.id)
                            dismiss()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }

                }
            }
            .onChange(of: homeVm.productMessage) { oldValue, newValue in
                if newValue == "product updated successfully" {
                    homeVm.getAllProducts(categoryId: category.id)
                }
            }
            .navigationDestination(for: ProductModel.self) { value in
                Text(value.name)
            }
        
    }
}

#Preview {
    CategoryProfileView(category: DeveloperPreview.instanse.categoryPreview, homeVm: HomeViewModel())
}
