//
//  ProductItemView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import SwiftUI

struct ProductItemView: View {
    
    let product: ProductModel
    let onPressAddBtn: () -> Void
    @StateObject var vm: ProductViewModel
    
    init(product: ProductModel, onPressAddBtn: @escaping () -> Void) {
        self.product = product
        _vm = StateObject(wrappedValue: ProductViewModel(product: product))
        self.onPressAddBtn = onPressAddBtn
    }
    
    var body: some View {
        VStack {
            Text(product.name.capitalized)
                .font(.title3)
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            if let productImage = vm.productImage {
                Image(uiImage: productImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            else{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100, height: 100)
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            }
            
            Text("\(product.price.doubleToStringPrice())")
                .font(.title3)
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Button {
                onPressAddBtn()
            } label: {
                Text("+ add".capitalized)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .background(Color.theme.btns_bg)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }

        }
        .frame(width: 150, height: 210)
        .padding()
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)

    }
}

#Preview {
    ProductItemView(product: DeveloperPreview.instanse.productPreview) {
        
    }
}
