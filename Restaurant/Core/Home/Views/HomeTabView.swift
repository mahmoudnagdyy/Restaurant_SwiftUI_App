//
//  HomeTabView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import SwiftUI

struct HomeTabView: View {
    
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    UserContent
                    
                    SearchBarView(searchText: $vm.searchText, placeholder: "find your food")
                    
                    offersContent
                    
                    HomeHeaderTextView(text: "categories")
                        .padding(.top, 20)

                    categoriesContent
                    
                    HStack{
                        HomeHeaderTextView(text: "popular")
                        Spacer()
                        Text("see all".capitalized)
                            .foregroundStyle(.red)
                            .font(.headline)
                    }
                    .padding(.top, 20)
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<10) { _ in
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 300, height: 300)
                            }
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                }
                .padding()
            }
            .navigationDestination(for: CategoryModel.self) { category in
                CategoryProfileView(category: category, homeVm: vm)
            }
        }
    }
}

#Preview {
    HomeTabView(vm: HomeViewModel())
}




extension HomeTabView {
    
    private var UserContent: some View {
        HStack {
            VStack(alignment: .leading) {
                let name = vm.user?.name.split(separator: " ").first ?? "john"
                Text("hi \(name)".capitalized)
                    .foregroundStyle(.red)
                    .font(.title2)
                    .bold()
                Text("order & eat".capitalized)
                    .font(.title3)
            }
            Spacer()
            
            if let profileImage = vm.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(.circle)
            }
            
            else{
                ProfileImageIconView
            }
                
        }
    }
    
    private var ProfileImageIconView: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
    }
    
    private var offersContent: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(Color.theme.btns_bg)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
    }
    
    private var categoriesContent: some View {
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
    
}
