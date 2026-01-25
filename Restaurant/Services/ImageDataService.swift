//
//  ImageDataService.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import Foundation
internal import Combine
import UIKit

class ImageDataService {
    
    var cancellables = Set<AnyCancellable>()
    @Published var downloadedImage: UIImage?
    
    init() {
        
    }
    
    func getImage(url: String, imageName: String){
        if let image = RestaurantFileManager.instance.getImageFromFileManager(imageName: imageName) {
            print("in file manager")
            self.downloadedImage = image
        }
        else{
            print("in server")
            downloadImage(url: url, imageName: imageName)
        }
        print(imageName + "hi")
    }
    
    func downloadImage(url: String, imageName: String){
        guard let url = URL(string: url) else {
            print("url is problem in download image from api")
            return
        }
        
        print("download image from api")
                        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return UIImage(data: data)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] image in
                guard let self else { return }
                self.downloadedImage = image
                if let image {
                    RestaurantFileManager.instance.saveImageToFileManager(image: image, imageName: imageName)
                }
            }
            .store(in: &cancellables)
        
    }
    
}
