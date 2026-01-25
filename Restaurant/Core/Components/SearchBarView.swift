//
//  SearchBarView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundStyle(.gray)
            TextField(placeholder.capitalized, text: $searchText)
                .font(.headline)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.vertical)
    }
}

#Preview {
    SearchBarView(searchText: .constant(""), placeholder: "find your food")
}
