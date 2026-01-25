//
//  CartItemView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 23/01/2026.
//

import SwiftUI

struct CartItemView: View {
    
    let cartItem: CartItem
    let onPressPlus: () -> Void
    let onPressMinus: () -> Void
    @StateObject var vm: ProductViewModel
    
    init(cartItem: CartItem, onPressPlus: @escaping () -> Void, onPressMinus: @escaping () -> Void) {
        self.cartItem = cartItem
        _vm = StateObject(wrappedValue: ProductViewModel(product: cartItem.product))
        self.onPressPlus = onPressPlus
        self.onPressMinus = onPressMinus
    }
    
    var body: some View {
        
        HStack {
            ProductImage
            
            VStack {
                ProductName
                ProductQuantity
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 50) {
                let productPrice = cartItem.product.price
                Text(productPrice.doubleToStringPrice())
                    .font(.headline)
                    .foregroundStyle(.secondary)
                let totalProductPrice = productPrice * Double(cartItem.quantity)
                Text(totalProductPrice.doubleToStringPrice())
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.theme.btns_bg)
            }
        }
        .padding()
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5, y: 2)
        
    }
}

#Preview {
    CartItemView(cartItem: CartItem(id: "123", product: DeveloperPreview.instanse.productPreview, quantity: 10)) {
        
    } onPressMinus: {
        
    }

}


extension CartItemView {
    
    private var ProductImage: some View {
        Group {
            if let productImage = vm.productImage {
                Image(uiImage: productImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(.circle)
            }
            else{
                Circle()
                    .frame(width: 100, height: 100)
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            }
        }
    }
    
    private var ProductName: some View {
        Text(cartItem.product.name.capitalized)
            .font(.title3)
            .bold()
    }
    
    private var ProductQuantity: some View {
        HStack {
            Button {
                onPressMinus()
            } label: {
                Text("-")
                    .font(.title3)
                    .frame(width: 40, height: 40)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text("\(cartItem.quantity)")
                .font(.headline)
            Button {
                onPressPlus()
            } label: {
                Text("+")
                    .font(.title3)
                    .frame(width: 40, height: 40)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
}
