//
//  AuthLabelView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct AuthLabelView: View {
    
    let text: String
    
    var body: some View {
        Text(text.capitalized)
            .foregroundStyle(.secondary)
            .font(.headline)
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AuthLabelView(text: "name")
}
