//
//  SignupDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import Foundation
internal import Combine

class SignupDataService {
    
    @Published var message: String = ""
    @Published var userId: String? = nil
    @Published var validationErrors: [String]? = nil
    
    var signupCancelable: AnyCancellable? = nil
    
    init() {
        
    }
    
    func downloadData(name: String, email: String, password: String, phone: String) {
        guard let url = URL(string: "http://localhost:5050/auth/signup") else { return }
        
        // set request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(SignupModel(name: name, email: email, password: password, phone: phone))
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        // send request and get Data
        signupCancelable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: SignupResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] SignupResponseModel in
                guard let self else { return }

                if SignupResponseModel.message == "Validation Error" {
                    self.message = SignupResponseModel.message
                    self.validationErrors = SignupResponseModel.validationErrors
                    self.userId = nil
                }
                else if SignupResponseModel.message == "email already exists" {
                    self.message = SignupResponseModel.message
                    self.validationErrors = nil
                    self.userId = nil
                }
                else if SignupResponseModel.message == "done" {
                    self.message = SignupResponseModel.message
                    self.validationErrors = nil
                    self.userId = SignupResponseModel.userId
                }
                else {
                    self.message = ""
                    self.validationErrors = nil
                    self.userId = nil
                }
            }

    }
    
}
