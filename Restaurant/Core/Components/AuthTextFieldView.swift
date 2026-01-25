//
//  AuthTextFieldView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct AuthTextFieldView: View {
    
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder.capitalized, text: $text)
            .font(.headline)
            .padding()
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    AuthTextFieldView(placeholder: "enter your name", text: .constant(""))
}
