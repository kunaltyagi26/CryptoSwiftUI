//
//  ImageManager.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 10/11/23.
//

import Combine
import UIKit

class ImageManager: ObservableObject {
    // MARK: - Variables
    let imageCache = NSCache<NSString, UIImage>()
    
    var dataService = DataService<Data>()
    @Published var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    
    /// Get image with URL
    /// - Parameter URLString: source urll
    /// - Returns: callback
    func loadImageUsingCache(withURLString urlString: String) {
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            image = cachedImage
        }
        
        dataService.getImageData(for: .getImage(url: urlString))
        dataService.$result
        .sink { [weak self] data in
            if let data = data {
                self?.image = UIImage(data: data)
            }
        }
        .store(in: &cancellables)
    }
}
