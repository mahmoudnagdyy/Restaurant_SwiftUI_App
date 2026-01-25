//
//  VerifyDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 19/01/2026.
//

import Foundation
internal import Combine


class VerifyDataService {
    
    @Published var message: String = ""
    @Published var validationErrors: [String]? = nil
    
    var verifyCancellable: AnyCancellable?
    
    init() {
        
    }
    
    func verifyEmail(verificationCode: String, userId: String) {
        guard let url = URL(string: "http://localhost:5050/auth/verify") else { return }
        
        print(userId, verificationCode)
        
        // set request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(VerifyModel(userId: userId, verificationCode: verificationCode))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //send request
        verifyCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: VerifyResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] VerifyResponse in
                guard let self else { return }
                self.message = VerifyResponse.message
                self.validationErrors = VerifyResponse.validationErrors
            })
    }
    
}


// email verified
