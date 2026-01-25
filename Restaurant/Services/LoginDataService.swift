//
//  LoginDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import Foundation
internal import Combine


class LoginDataService {
    
    @Published var message: String = ""
    @Published var token: String? = nil
    @Published var validationErrors: [String]? = nil
    
    var loginCancellable: AnyCancellable? = nil
    
    init () {
        
    }
    
    func login(email: String, password: String) {
        guard let url = URL(string: "http://localhost:5050/auth/login") else { return }
        
        // set request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(LoginModel(email: email, password: password))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        loginCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: LoginResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] LoginResponseModel in
                guard let self else { return }
                self.message = LoginResponseModel.message
                self.token = LoginResponseModel.token
                self.validationErrors = LoginResponseModel.validationErrors
            }
        
    }
    
}
