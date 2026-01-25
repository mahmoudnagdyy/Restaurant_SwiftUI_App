//
//  AuthFooterView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct AuthFooterView: View {
    
    let askText: String
    let actionText: String
    let onAction: () -> Void
    
    var body: some View {
        HStack {
            Text(askText)
                .foregroundStyle(.secondary)
            Text(actionText.capitalized)
                .font(.headline)
                .foregroundStyle(Color(#colorLiteral(red: 0.8509803922, green: 0.1411764706, blue: 0.1411764706, alpha: 1)))
                .onTapGesture {
                    onAction()
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
    }
}

#Preview {
    AuthFooterView(askText: "Already have an account?", actionText: "login") {
        
    }
}
