//
//  ProfileTabView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 21/01/2026.
//

import SwiftUI
import PhotosUI

struct ProfileTabView: View {
    
    @ObservedObject var vm: HomeViewModel
    let onPressLogout: () -> Void
    
    var body: some View {
        
        ZStack {
            //background
            Color.theme.auth_bg.ignoresSafeArea()
            
            //foreground
            VStack(alignment: .leading){ // start: vstack
                ProfileImageView
                PersonalInfoView
            } // end: vstack
            
        }
        
    }
}

#Preview {
    ProfileTabView(vm: HomeViewModel()) {
        
    }
}



extension ProfileTabView {
    
    private var ProfileImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let profileImage = vm.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(.circle)
            }
            else{
                ProfileImageIconView
            }
            
            PhotoPickerView
            
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.theme.btns_bg)
    }
    
    private var ProfileImageIconView: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
    }
    
    private var PhotoPickerView: some View {
        PhotosPicker(selection: $vm.selectedUserImage, matching: .images) {
            if vm.isLoading {
                ProgressView()
                    .tint(.white)
            }
            else{
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
        }
        .disabled(vm.isLoading)
    }
    
    private var PersonalInfoView: some View {
        ScrollView {
            VStack(spacing: 20) {
                ProfileInfoRawView(iconName: "person.fill", title: vm.user?.name.capitalized ?? "no name")
                
                ProfileInfoRawView(iconName: "envelope.fill", title: vm.user?.email ?? "no name")
                
                ProfileInfoRawView(iconName: "iphone.gen2", title: vm.user?.phone ?? "no phone")
                
                ProfileInfoRawView(iconName: "checkmark.circle.fill", title: (vm.user?.isVerified ?? false) ? "verified".capitalized : "not verified".capitalized)
                
                ProfileInfoRawView(iconName: "figure.walk", title: vm.user?.role ?? "no role")
                
                Button {
                    onPressLogout()
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "loggedInUserId")
                } label: {
                    HStack {
                        Text("logout".capitalized)
                        Image(systemName: "iphone.and.arrow.forward.outward")
                    }
                    .font(.headline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.theme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                
            }
            .padding()
        }
    }
    
}
