//
//  LoginViewModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import Foundation
internal import Combine
import SwiftUI


class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var message: String = ""
    @Published var validationErrors: [String]? = nil
    
    @Published var submitState: SubmitStates = .idle
    
    var cancellables = Set<AnyCancellable>()
    
    private let loginService = LoginDataService()
    
    init() {
        addSubscribers()
    }
    
    func login() {
        loginService.login(email: email, password: password)
    }
    
    private func addSubscribers() {
        loginService.$message
            .combineLatest(loginService.$token, loginService.$validationErrors)
            .sink { [weak self] message, token, validationErrors in
                guard let self else { return }
                self.message = message
                self.validationErrors = validationErrors
                if let token = token {
                    UserDefaults.standard.set(token, forKey: "token")
                }
                
                if message == "done" {
                    email = ""
                    password = ""
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
            }
        }
        
    }
    
}
