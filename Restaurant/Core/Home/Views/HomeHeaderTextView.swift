//
//  HomeHeaderTextView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import SwiftUI

struct HomeHeaderTextView: View {
    
    let text: String
    
    var body: some View {
        Text(text.capitalized)
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeHeaderTextView(text: "categories")
}
