//
//  SubmitButtonView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct SubmitButtonView: View {
    
    let title: String
    let onAction: () -> Void
    @Binding var submitState: SubmitStates
    
    var body: some View {
        Button {
            onAction()
        } label: {
            switch submitState {
            case .idle:
                Text(title.capitalized)
            case .loading:
                ProgressView()
                    .tint(.white)
            case .mark:
                Image(systemName: "checkmark.circle.fill")
            }
        }
        .frame(maxWidth: .infinity)
        .font(.headline)
        .foregroundStyle(.white)
        .padding()
        .background(Color.theme.btns_bg)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.vertical, 10)
    }
}

#Preview {
    SubmitButtonView(title: "login", onAction: {
        
    }, submitState: .constant(.idle))
}
