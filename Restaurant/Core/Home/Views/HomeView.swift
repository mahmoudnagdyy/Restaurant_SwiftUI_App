//
//  HomeView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = HomeViewModel()
    let onPressLogout: () -> Void
    
    var body: some View {
        
        ZStack {
            // background
            Color.theme.background.ignoresSafeArea()
            
            // foreground
            TabViewContent
        }
        
    }
}

#Preview {
    HomeView {
        
    }
}



extension HomeView {
    
    private var TabViewContent: some View {
        
        TabView {
            Tab {
                HomeTabView(vm: vm)
            } label: {
                TabLabelView(text: "home", iconName: "house.fill")
            }
            
            Tab {
                ProfileTabView(vm: vm) {
                    onPressLogout()
                }
            } label: {
                TabLabelView(text: "profile", iconName: "person.fill")
            }
            
            Tab {
                CartTabView(cart: vm.cart ?? DeveloperPreview.instanse.cartPreview, vm: vm)
            } label: {
                TabLabelView(text: "cart", iconName: "cart.fill")
            }
            .badge(vm.cart?.items.count ?? 0)
            
            if let user = vm.user {
                if user.role == "admin" {
                    Tab {
                        ManageView(vm: vm)
                    } label: {
                        TabLabelView(text: "manage", iconName: "gearshape.fill")
                    }
                }
            }

        }
        .tint(Color.theme.btns_bg)
    }
    
}
