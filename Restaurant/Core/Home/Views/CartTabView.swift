//
//  CartTabView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 23/01/2026.
//

import SwiftUI

struct CartTabView: View {
    
    let cart: CartModel
    @ObservedObject var homeVM: HomeViewModel
    @State var totalPrice: Double = 0
    
    init(cart: CartModel, vm: HomeViewModel) {
        self.cart = cart
        self.homeVM = vm
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                CartTitle
                CartItemsView
                                
                Spacer()
            }
            .padding(10)
            .background(Color.theme.background)
            .onChange(of: cart.totalPrice) { oldValue, newValue in
                print(newValue)
            }
            
        }
        .scrollIndicators(.hidden)

        
    }
}

#Preview {
    CartTabView(cart: CartModel(id: "", items: [], totalPrice: 0, user: ""), vm: HomeViewModel())
}


extension CartTabView {
    
    private var CartTitle: some View {
        Text("my cart".capitalized)
            .foregroundStyle(.red)
            .font(.largeTitle)
            .bold()
    }
    
    private var CartItemsView: some View {
        Group {
            if cart.items.count > 0 {
                VStack(spacing: 30) {
                    ForEach(cart.items) { item in                        CartItemView(cartItem: item) {
                            homeVM.updateCart(cartId: cart.id, product: item.product, quantity: item.quantity + 1)
                        } onPressMinus: {
                            homeVM.updateCart(cartId: cart.id, product: item.product, quantity: item.quantity - 1)
                        }
                    }
                }
                CartTotalView
            }
            else{
                Text("no items in your cart.".capitalized)
                    .offset(y: 300)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var CartTotalView: some View {
        HStack {
            Text("total".capitalized)
            Spacer()
            Text(cart.totalPrice.doubleToStringPrice())
        }
        .font(.largeTitle)
        .bold()
        .padding(.vertical, 10)
    }
    
}
