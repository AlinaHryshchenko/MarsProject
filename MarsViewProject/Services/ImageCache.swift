

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    let cache = NSCache<NSString, UIImage>()
}

extension UIImageView {
    func renderImageWithColor(image: UIImage, color: UIColor) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func loadImageAndCache(urlString: String) {
        if let imageFromCache = ImageCache.shared.cache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        guard let imageURL = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: imageURL)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        self.saveImageToCache(image: image, urlString: urlString)
                    }
                } else {
                    print("Failed to create image from data for URL: \(urlString)")
                }
            } catch let error {
                print("Error loaded photo: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveImageToCache(image: UIImage, urlString: String) {
        ImageCache.shared.cache.setObject(image, forKey: urlString as NSString)
    }
}
