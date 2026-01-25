//
//  OrSeparatorView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct OrSeparatorView: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray.opacity(0.5))
                .frame(width: 120, height: 1)
            Text("or".capitalized)
                .font(.headline)
                .foregroundStyle(.secondary)
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray.opacity(0.5))
                .frame(width: 120, height: 1)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OrSeparatorView()
}
