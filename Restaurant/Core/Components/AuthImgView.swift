//
//  AuthImgView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct AuthImgView: View {
    
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
    }
}

#Preview {
    AuthImgView(imageName: "loginImg")
}
