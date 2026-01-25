//
//  RestaurantFileManager.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 23/01/2026.
//

import Foundation
import UIKit


class RestaurantFileManager {
    
    static let instance = RestaurantFileManager()
    
    private init() {}
    
    
    func saveImageToFileManager(image: UIImage, imageName: String) {
        print("Save Image To File Manager")
        
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: "Restaurant")
        else {
            print("Failed to create image data or directory URL")
            return
        }
        
        do {
            if !FileManager.default.fileExists(atPath: path.path) {
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
            }
        } catch {
            print("Error creating directory for user data with error: \(error.localizedDescription)")
        }
        
        let fileUrl = path.appending(path: imageName + ".jpg")
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        do {
            try imageData?.write(to: fileUrl)
        } catch {
            print("Error saving image with error: \(error.localizedDescription)")
        }
        
    }
    
    func getImageFromFileManager(imageName: String) -> UIImage? {
        print("Get Image From File Manager")
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: "Restaurant"),
              FileManager.default.fileExists(atPath: path.appending(path: imageName + ".jpg").path)
        else {
            print("no image found in file manager")
            return nil
        }
        
        return UIImage(contentsOfFile: path.appending(path: imageName + ".jpg").path)
    }
    
}
