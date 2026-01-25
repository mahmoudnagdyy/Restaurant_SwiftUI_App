//
//  SignupViewModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import Foundation
internal import Combine
import SwiftUI


class SignupViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var phone: String = ""
    
    @Published var message: String = ""
    @Published var userId: String? = nil
    @Published var validationError: [String]? = nil
    
    let nameError = "Name must >= 3 chars, and < 20 chars."
    let emailError = "Enter a valid Email."
    let passwordError = "Password must >= 6 chars."
    let phoneError = "Enter a valid Phone Number."
    
    @Published var submitState: SubmitStates = .idle
    
    @Published var showVerifySheet: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    private let signupService = SignupDataService()
    
    init() {
        addSubscribers()
    }
    
    func signup() {
        signupService.downloadData(name: name, email: email, password: password, phone: phone)
    }
    
    private func addSubscribers() {
        
        signupService.$message
            .combineLatest(signupService.$userId, signupService.$validationErrors)
            .sink { [weak self] message, userId, validationErrors in
                guard let self else { return }
                
                print(message, userId ?? "no userId", validationErrors ?? "no validationErrors")
                self.message = message
                self.userId = userId
                self.validationError = validationErrors
                
                if message == "done" {
                    name = ""
                    email = ""
                    password = ""
                    phone = ""
                    
                    if let userId {
                        UserDefaults.standard.set(userId, forKey: "userId")
                    }
                    
                    animateSubmitButton()
                }
                
            }
            .store(in: &cancellables)
        
    }
    
    private func animateSubmitButton() {
        
        submitState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.submitState = .mark
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation {
                self.submitState = .idle
                self.showVerifySheet.toggle()
            }
        }
        
    }
    
}
