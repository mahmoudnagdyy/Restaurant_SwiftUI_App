//
//  SignupView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject var vm = SignupViewModel()
    
    enum FocusFields {
        case name, email, password, phone
    }
    
    @FocusState var focusedField: FocusFields?
    
    let onPressLogin: () -> Void
    let onVerificationSuccess: () -> Void
    
    var body: some View {
        ZStack {
            // background
            Color.theme.auth_bg.ignoresSafeArea()
            
            // foreground
            VStack(spacing: 0) {
                AuthImgView(imageName: "signupImg")
                signupFormContainer
            }
        }
    }
}

#Preview {
    SignupView {
        
    } onVerificationSuccess: {
        
    }

}


// subviews
extension SignupView {
    
    private var signupFormContainer: some View {
        ZStack(alignment: .topLeading) {
            // background
            Color.theme.background
                .clipShape(
                    UnevenRoundedRectangle(topLeadingRadius: 40, topTrailingRadius: 40)
                )
                .ignoresSafeArea()
            
            //foreground
            signupForm
        }
    }
    
    private var signupForm: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AuthHeaderTextView(title: "signup")
                
                nameTextField
                    .focused($focusedField, equals: .name)
                
                emailTextField
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                
                passwordTextField
                    .focused($focusedField, equals: .password)
                
                phoneTextField
                    .keyboardType(.phonePad)
                    .focused($focusedField, equals: .phone)
                
                SubmitButtonView(title: "signup", onAction: {
                    vm.signup()
                    focusedField = nil
                }, submitState: $vm.submitState)
                .sheet(isPresented: $vm.showVerifySheet) {
                    VerifyView {
                        onVerificationSuccess()
                    }
                }
                
                OrSeparatorView()
                
                AuthFooterView(askText: "Already have an account?", actionText: "login") {
                    onPressLogin()
                }
                
            }
            .padding(25)
            .onSubmit {
                submitFunction()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var nameTextField: some View {
        Group {
            AuthLabelView(text: "name")
            AuthTextFieldView(placeholder: "enter your name", text: $vm.name)
            
            if let validationErrors = vm.validationError {
                if validationErrors.contains(where: {$0 == "name"}) {
                    ErrorTextView(errorText: vm.nameError)
                }
            }
        }
    }
    
    private var emailTextField: some View {
        Group {
            AuthLabelView(text: "email")
            AuthTextFieldView(placeholder: "enter your email", text: $vm.email)
            
            if let validationErrors = vm.validationError {
                if validationErrors.contains(where: {$0 == "email"}) {
                    ErrorTextView(errorText: vm.emailError)
                }
            }
            
            if vm.message == "email already exists" {
                ErrorTextView(errorText: vm.message.capitalized)
            }
        }
    }
    
    private var passwordTextField: some View {
        Group {
            AuthLabelView(text: "password")
            PasswordFieldView(placeholder: "enter your password", text: $vm.password)
            
            if let validationErrors = vm.validationError {
                if validationErrors.contains(where: {$0 == "password"}) {
                    ErrorTextView(errorText: vm.passwordError)
                }
            }
        }
    }
    
    private var phoneTextField: some View {
        Group {
            AuthLabelView(text: "phone")
            AuthTextFieldView(placeholder: "enter your phone", text: $vm.phone)
            
            if let validationErrors = vm.validationError {
                if validationErrors.contains(where: {$0 == "phone"}) {
                    ErrorTextView(errorText: vm.phoneError)
                }
            }
        }
    }
    
}


// functions
extension SignupView {
    
    private func submitFunction() {
        switch focusedField {
            case .name:
                focusedField = .email
            case .email:
                focusedField = .password
            case .password:
                focusedField = .phone
            case .phone:
                focusedField = nil
                vm.signup()
            case nil:
                break
            }
    }
    
}
