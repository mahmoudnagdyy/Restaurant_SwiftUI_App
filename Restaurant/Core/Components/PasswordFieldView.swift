//
//  PasswordFieldView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct PasswordFieldView: View {
    
    let placeholder: String
    @Binding var text: String
    
    @State var showPassword: Bool = false
    
    var body: some View {
        
        HStack {
            if showPassword {
                TextField(placeholder.capitalized, text: $text)
            }
            else{
                SecureField(placeholder.capitalized, text: $text)
            }

            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                .onTapGesture {
                    showPassword.toggle()
                }
        }
        .font(.headline)
        .padding()
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
    }
}

#Preview {
    PasswordFieldView(placeholder: "enter your password", text: .constant(""))
}
