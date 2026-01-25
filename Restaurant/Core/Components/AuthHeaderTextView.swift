//
//  AuthHeaderTextView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct AuthHeaderTextView: View {
    
    let title: String
    
    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 35))
            .bold()
    }
}

#Preview {
    AuthHeaderTextView(title: "signup")
}
