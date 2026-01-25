//
//  HomeDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 20/01/2026.
//

import Foundation
internal import Combine
import UIKit


class UserDataService {
    
    @Published var user: UserModel? = nil
    @Published var profileImage: UIImage? = nil
    
    @Published var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    let imageService = ImageDataService()
    
    init() {
        getUserData()
    }
    
    
    private func getUserData() {
        if let user = UserCoreData.instance.getUserFromCoreData() {
            self.user = user
            if let image = RestaurantFileManager.instance.getImageFromFileManager(imageName: user.id) {
                self.profileImage = image
            }
        }
        else{
            getUser()
        }
    }
    
    private func getUser() {
        guard let url = URL(string: "http://localhost:5050/user") else { return }
        print("download user from api")
        // set request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("marmoush__\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: UserResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] UserResponseModel in
                guard let self else { return }
                self.user = UserResponseModel.user
                                
                if let user = UserResponseModel.user {
                    if UserDefaults.standard.value(forKey: "loggedInUserId") == nil {
                        UserCoreData.instance.saveUserToCoreData(user: user)
                        UserCoreData.instance.updateUserProfileImageInCoreData(userId: user.id, profileImage: UserImage(public_id: user.profileImage?.public_id ?? "", secure_url: user.profileImage?.secure_url ?? ""))
                        UserDefaults.standard.set(user.id, forKey: "loggedInUserId")
                    }
                }
                
                if let image = UserResponseModel.user?.profileImage {
                    imageService.getImage(url: image.secure_url, imageName: user?.id ?? "")
                }
                
            })
            .store(in: &cancellables)
        
        imageService.$downloadedImage
            .sink { [weak self] img in
                guard let self else { return }
                self.profileImage = img
            }
            .store(in: &cancellables)
        
    }
    
    func uploadPhoto(imageData: Data, imageName: String) {
        guard let url = URL(string: "http://localhost:5050/user") else { return }
        
        isLoading = true
        
        // set request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("marmoush__\(token)", forHTTPHeaderField: "Authorization")
        
        var body = Data()
            
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // send request
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: UserResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                print(completion)
            } receiveValue: { [weak self] UserResponseModel in
                guard let self else { return }
                if UserResponseModel.message == "done"{
                    if let img = UIImage(data: imageData) {
                        RestaurantFileManager.instance.saveImageToFileManager(image: img, imageName: imageName)
                        getUserData()
                        self.profileImage = img
                    }
                    
                }
            }
            .store(in: &cancellables)

    }
    
}
