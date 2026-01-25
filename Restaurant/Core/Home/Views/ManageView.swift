//
//  ManageView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 21/01/2026.
//

import SwiftUI

struct ManageView: View {
    
    @ObservedObject var vm: HomeViewModel
    
    @State var path = NavigationPath()
    
    var body: some View {
        
        ZStack {
            // background
            Color.theme.background.ignoresSafeArea()
            
            //foreground
            NavigationStack(path: $path) { // start: navigationView
                
                ScrollView { //start: scrollview
                    
                    VStack { //start: vstack
                        
                        Text("welcome back".capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        
                        ManageHeaderView(showSheet: $vm.showCategoriesSheet, text: "categories")
                        .sheet(isPresented: $vm.showCategoriesSheet) {
                            AddCategoryView(vm: vm)
                        }
                        
                        if vm.categories.count > 0 {
                            ScrollView(.horizontal) {
                                LazyHStack{
                                    ForEach(vm.categories) { category in
                                        NavigationLink(value: category) {
                                            CategoryItemView(category: category)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                            .scrollIndicators(.hidden)
                        }
                        else{
                            Text("no categories yet.".capitalized)
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(.gray)
                        }
                        
                        
                        Spacer()
                    } // end: vstack
                    .padding(.horizontal)
                    
                } //end: scrollview
                .navigationDestination(for: CategoryModel.self) { category in
                    CategoryProfileView(category: category, homeVm: vm)
                }
                
            } // end: navigationView

            
        }
        
    }
}

#Preview {
    ManageView(vm: HomeViewModel())
}
