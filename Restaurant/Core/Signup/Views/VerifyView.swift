//
//  VerifyView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import SwiftUI

struct VerifyView: View {
    
    @StateObject var vm = VerifyViewModel()
    @Environment(\.dismiss) var dismiss
    
    let onVerificationSuccess: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            Color.theme.verify_bg.ignoresSafeArea()
            
            // foreground
            verifyContent
        }
    }
}

#Preview {
    VerifyView {
        
    }
}


extension VerifyView {
    
    private var verifyContent: some View {
        VStack {
            CircleButtonView(iconName: "xmark") {
                dismiss()
            }
            
            Image("verifyImg")
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 270)
            
            Text("Enter OTP")
                .font(.title2)
                .bold()
            
            Text("A code has been sent to your email, please don't close this window.")
                .foregroundStyle(.secondary)
            
            AuthTextFieldView(placeholder: "Enter OTP", text: $vm.verificationCode)
            
            if vm.message == "Wrong verification code"{
                ErrorTextView(errorText: vm.message)
            }
            
            if let validationErrors = vm.validationErrors {
                if validationErrors.contains(where: {$0 == "verificationCode"}) {
                    ErrorTextView(errorText: vm.verificationCodeError)
                }
            }
            
            SubmitButtonView(title: "verify", onAction: {
                vm.verify()
            }, submitState: $vm.submitState)
                            
            Spacer()
        }
        .padding()
        .onChange(of: vm.message) { oldValue, newValue in
            if newValue == "done" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    dismiss()
                    onVerificationSuccess()
                }
            }
        }
    }
    
}
