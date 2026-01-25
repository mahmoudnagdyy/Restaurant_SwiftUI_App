//
//  ManageHeaderView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 21/01/2026.
//

import SwiftUI

struct ManageHeaderView: View {
    
    @Binding var showSheet: Bool
    let text: String
    
    var body: some View {
        HStack {
            HomeHeaderTextView(text: text)
            Spacer()
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(Color.theme.accent)
                    .padding()
                    .background(.white)
                    .clipShape(.circle)
                    .shadow(radius: 10)
            }
            
        }
    }
}

#Preview {
    ManageHeaderView(showSheet: .constant(true), text: "categories")
}
