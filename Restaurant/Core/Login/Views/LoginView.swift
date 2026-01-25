//
//  LoginView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm = LoginViewModel()
    
    let onPressSignup: () -> Void
    let onLoginSuccess: () -> Void
    
    var body: some View {
        
        ZStack {
            // background
            Color.theme.auth_bg.ignoresSafeArea()
            
            // foreground
            VStack {
                AuthImgView(imageName: "loginImg")
                loginFormContainer
            }
        }
        
    }
}

#Preview {
    LoginView {
        
    } onLoginSuccess: {
        
    }

}


extension LoginView {
    
    private var loginFormContainer: some View {
        ZStack(alignment: .topLeading) {
            //background
            Color.theme.background
                .clipShape(
                    UnevenRoundedRectangle(topLeadingRadius: 40, topTrailingRadius: 40)
                )
                .ignoresSafeArea()
            
            // foreground
            loginForm
        }
    }
    
    private var loginForm: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AuthHeaderTextView(title: "login")
                
                emailTextField
                    .keyboardType(.emailAddress)
                
                passwordTextField
                
                SubmitButtonView(title: "login", onAction: {
                    vm.login()
                }, submitState: $vm.submitState)
                
                OrSeparatorView()
                
                AuthFooterView(askText: "Don't have an account?", actionText: "signup") {
                    onPressSignup()
                }
            }
            .padding(25)
            .onChange(of: vm.message) { oldValue, newValue in
                if UserDefaults.standard.string(forKey: "token") != nil &&
                    newValue == "done" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        onLoginSuccess()
                    }
                }
            }
        }
    }
    
    private var emailTextField: some View {
        Group {
            AuthLabelView(text: "email")
            AuthTextFieldView(placeholder: "enter your email", text: $vm.email)
            
            if let validationErrors = vm.validationErrors {
                if validationErrors.contains(where: {$0 == "email"}){
                    ErrorTextView(errorText: "Please enter a valid email")
                }
            }
            
            if vm.message == "user not found" {
                ErrorTextView(errorText: vm.message.capitalized)
            }
            else if vm.message == "Email is not verified" {
                ErrorTextView(errorText: vm.message)
            }
        }
    }
    
    private var passwordTextField: some View {
        Group {
            AuthLabelView(text: "password")
            PasswordFieldView(placeholder: "enter your password", text: $vm.password)
            
            if let validationErrors = vm.validationErrors {
                if validationErrors.contains(where: {$0 == "password"}){
                    ErrorTextView(errorText: "Please enter a valid password")
                }
            }
            
            if vm.message == "wrong password" {
                ErrorTextView(errorText: vm.message.capitalized)
            }
        }
    }
    
}
