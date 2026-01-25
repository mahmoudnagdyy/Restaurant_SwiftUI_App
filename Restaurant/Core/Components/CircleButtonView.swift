//
//  CircleButtonView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    let onAction: () -> Void
    
    var body: some View {
        Image(systemName: iconName)
            .font(.title3)
            .bold()
            .padding()
            .background(Color.theme.btns_bg)
            .foregroundStyle(.white)
            .clipShape(Circle())
            .shadow(radius: 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                onAction()
            }
    }
}

#Preview {
    CircleButtonView(iconName: "xmark") {
        
    }
}
