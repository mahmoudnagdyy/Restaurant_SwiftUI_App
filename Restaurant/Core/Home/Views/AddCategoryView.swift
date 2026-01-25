//
//  AddCategoryView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 21/01/2026.
//

import SwiftUI
import PhotosUI

struct AddCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        
        ZStack {
            // background
            Color.theme.background
            
            // foreground
            VStack {
                
                CircleButtonView(iconName: "xmark") {
                    dismiss()
                }
                
                PhotosPickerView
                
                AuthTextFieldView(placeholder: "enter category name", text: $vm.categoryName)
                    .padding(.top)
                
                if let categoryMessage = vm.categoryMessage,
                   categoryMessage == "Category already exists" {
                    ErrorTextView(errorText: categoryMessage.capitalized)
                }
                
                if let validationErrors = vm.categoryValidationErrors,
                   validationErrors.contains(where: {$0 == "name"}) {
                    ErrorTextView(errorText: "Enter a valid name")
                }
                
                
                addCategoryBtnView

                
                Spacer()
                
            }
            .padding()
        }
        
    }
}

#Preview {
    AddCategoryView(vm: HomeViewModel())
}


extension AddCategoryView {
    
    private var ProfileImageIconView: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
    }
    
    private var PhotosPickerView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let addCategoryImage = vm.addCategoryImage {
                Image(uiImage: addCategoryImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(.circle)
            }
            else{
                ProfileImageIconView
            }
            
            PhotosPicker(selection: $vm.selectedCategoryImage, matching: .images) {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.theme.accent)
            }
        }
    }
    
    private var addCategoryBtnView: some View {
        Button {
            Task{
                await vm.addCategory()
            }
        } label: {
            if vm.isAddingCategory {
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
        .disabled(vm.selectedCategoryImage == nil ? true : false)
        .opacity(vm.selectedCategoryImage == nil ? 0.6 : 1)
    }
    
}
