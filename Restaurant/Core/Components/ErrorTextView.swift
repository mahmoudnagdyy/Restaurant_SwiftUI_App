//
//  ErrorTextView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct ErrorTextView: View {
    
    let errorText: String
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle.fill")
            Text(errorText)
        }
        .font(.headline)
        .foregroundStyle(.red)
        .padding(2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ErrorTextView(errorText: "")
}
