//
//  ProductViewModel.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import Foundation
internal import Combine
import UIKit


class ProductViewModel: ObservableObject {
    
    let product: ProductModel
    @Published var productImage: UIImage?
    
    var cancellables = Set<AnyCancellable>()
    
    let imageService = ImageDataService()
    
    init (product: ProductModel) {
        self.product = product
        getProductImage(product: product)
    }
    
    func getProductImage(product: ProductModel) {
        
        imageService.getImage(url: product.image.secure_url, imageName: product.id)
        
        print("getting image for \(product.name)")
        
        imageService.$downloadedImage
            .sink { [weak self] img in
                guard let self else { return }
                self.productImage = img
            }
            .store(in: &cancellables)

    }
}
