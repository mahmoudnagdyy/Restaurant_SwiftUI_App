//
//  ProfileInfoRawView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 21/01/2026.
//

import SwiftUI

struct ProfileInfoRawView: View {
    
    let iconName: String
    let title: String
    
    var body: some View {
        HStack{
            Image(systemName: iconName)
            Text(title)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .font(.headline)
    }
}

#Preview {
    ProfileInfoRawView(iconName: "person.fill", title: "nagdy")
}
