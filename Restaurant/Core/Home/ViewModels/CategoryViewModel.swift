//
//  CategoryViewModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import Foundation
internal import Combine
import UIKit


class CategoryViewModel: ObservableObject {
    
    @Published var categoryImage: UIImage?
    
    let category: CategoryModel
    
    var cancellables = Set<AnyCancellable>()
    
    let imageService = ImageDataService()
    
    init(category: CategoryModel) {
        self.category = category
        getCategoryImage(category: category)
    }
    
    func getCategoryImage(category: CategoryModel) {
        imageService.getImage(url: category.image.secure_url, imageName: category.name)

        imageService.$downloadedImage
            .sink { [weak self] img in
                guard let self else { return }
                self.categoryImage = img
            }
            .store(in: &cancellables)
    }
    
    
}
