//
//  TabLabelView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import SwiftUI

struct TabLabelView: View {
    
    let text: String
    let iconName: String
    
    var body: some View {
        Label {
            Text(text.capitalized)
        } icon: {
            Image(systemName: iconName)
        }

    }
}

#Preview {
    TabLabelView(text: "home", iconName: "house.fill")
}
