//
//  VerifyViewModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import Foundation
internal import Combine
import SwiftUI


class VerifyViewModel: ObservableObject {
    @Published var verificationCode: String = ""
    
    @Published var submitState: SubmitStates = .idle
    
    @Published var message: String = ""
    @Published var validationErrors: [String]? = nil
    
    let verificationCodeError = "Please enter a valid code"
    
    private let verifySerice = VerifyDataService()
    
    var cancellables = Set<AnyCancellable>()
    
    init () {
        addSubscribers()
    }
    
    func verify() {
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            verifySerice.verifyEmail(verificationCode: verificationCode, userId: userId)
        }

    }
    
    private func addSubscribers() {
        verifySerice.$message
            .combineLatest(verifySerice.$validationErrors)
            .sink { [weak self] msg, validationErrors in
                guard let self else { return }
                self.message = msg
                self.validationErrors = validationErrors
                
                if msg == "done" {
                    verificationCode = ""
                    UserDefaults.standard.removeObject(forKey: "userId")
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
