//
//  AddProductView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @Environment(\.dismiss) var dismiss
    let category: CategoryModel
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                CircleButtonView(iconName: "xmark") {
                    dismiss()
                }
                
                ZStack(alignment: .bottomTrailing) {
                    if let addProductImage = vm.addProductImage {
                        Image(uiImage: addProductImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(.circle)
                    }
                    else{
                        ProfileImageIconView
                    }
                    
                    PhotosPicker(selection: $vm.selectedProductImage) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                .padding(.bottom)
                
                AuthLabelView(text: "name")
                AuthTextFieldView(placeholder: "enter product name", text:$vm.productName)
                
                if let validationErrors = vm.productValidationErrors,
                   validationErrors.contains(where: {$0 == "name"}) {
                    ErrorTextView(errorText: "product name must be >= 3 and <= 30 characters")
                }
                
                AuthLabelView(text: "price")
                AuthTextFieldView(placeholder: "enter product price", text: $vm.productPrice)
                
                if let validationErrors = vm.productValidationErrors,
                   validationErrors.contains(where: {$0 == "price"}) {
                    ErrorTextView(errorText: "price must be a number and > 0")
                }
                
                AuthLabelView(text: "description")
                TextEditor(text: $vm.productDiscription)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                if let validationErrors = vm.productValidationErrors,
                   validationErrors.contains(where: {$0 == "description"}) {
                    ErrorTextView(errorText: "discription must be >= 3 and <= 500 characters")
                }
                
                if let message = vm.productMessage,
                message != "",
                message != "product created successfully" {
                    ErrorTextView(errorText: message)
                }
                
                addProductBtnView

                
                
            }
            .padding()
            .onChange(of: vm.productMessage) { oldValue, newValue in
                if newValue == "product created successfully" {
                    vm.productName = ""
                    vm.productPrice = ""
                    vm.productDiscription = ""
                    vm.selectedProductImage = nil
                    vm.addProductImage = nil
                    dismiss()
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AddProductView(category: DeveloperPreview.instanse.categoryPreview, vm: HomeViewModel())
}



extension AddProductView {
    
    private var ProfileImageIconView: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
    }
    
    private var addProductBtnView: some View {
        Button {
            Task{
                await vm.addProduct(categoryId: category.id)
            }
        } label: {
            if vm.isAddingProduct {
                ProgressView()
                    .tint(.white)
            }
            else{
                Text("add".capitalized)
            }
        }
        .font(.title3)
        .bold()
        .foregroundStyle(.accent)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.theme.btns_bg)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.vertical)
        .disabled(vm.selectedProductImage == nil ? true : false)
        .opacity(vm.selectedProductImage == nil ? 0.6 : 1)
    }
    
}
