//
//  CategoryItemView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import SwiftUI

struct CategoryItemView: View {
    
    let category: CategoryModel
    @StateObject var vm: CategoryViewModel
    
    init(category: CategoryModel) {
        self.category = category
        _vm = StateObject(wrappedValue: CategoryViewModel(category: category))
    }
    
    var body: some View {
        VStack{
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
            
            Text(category.name.capitalized)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
        }
    }
}

#Preview {
    CategoryItemView(category: DeveloperPreview.instanse.categoryPreview)
}
