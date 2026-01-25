//
//  ContentView.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 18/01/2026.
//

import SwiftUI
internal import Combine

struct ContentView: View {
    
    enum AllScreens {
        case start, home, login, signup
    }
    
    @StateObject var vm = ContentViewViewModel()
    
    @State var currentScreen: AllScreens = UserDefaults.standard.string(forKey: "token") != nil ? .home : .login
    
    var body: some View {
        
        switch currentScreen {
        case .start:
            Text("start")
        case .home:
            HomeView {
                withAnimation(.easeInOut(duration: 1)) {
                    currentScreen = .login
                }
            }
            .transition(.scale)
            .onAppear {
                vm.isServerReachable()
            }
        case .login:
            LoginView {
                withAnimation(.easeInOut(duration: 1)) {
                    currentScreen = .signup
                }
            } onLoginSuccess: {
                withAnimation(.easeInOut(duration: 1)) {
                    currentScreen = .home
                }
            }
            .transition(.move(edge: .leading))

        case .signup:
            SignupView {
                withAnimation(.easeInOut(duration: 1)) {
                    currentScreen = .login
                }
            } onVerificationSuccess: {
                withAnimation(.easeInOut(duration: 1)) {
                    currentScreen = .login
                }
            }
            .transition(.move(edge: .trailing))

        }
        
    }
}

#Preview {
    ContentView()
}




class ContentViewViewModel: ObservableObject {
    
    static let instance = ContentViewViewModel()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        isServerReachable()
        UserDefaults.standard.set(false, forKey: "isOn")
    }
    
    func isServerReachable() {
        guard let url = URL(string: "http://127.0.0.1:5050") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return String(data: data, encoding: .utf8) ?? ""
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished here")
                    UserDefaults.standard.set(true, forKey: "isOn")
                case .failure(_):
                    print("failed")
                    UserDefaults.standard.set(false, forKey: "isOn")
                }
            }, receiveValue: { x in
                print(x)
            })
            .store(in: &cancellables)
        
    }
    
    
}
