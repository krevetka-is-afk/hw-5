import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.serastvorovPW5.imagecache")
    
    private init() {
        cache.countLimit = 100 // Максимальное количество изображений в кэше
    }
    
    func set(_ image: UIImage, for key: String) {
        queue.async {
            self.cache.setObject(image, forKey: key as NSString)
        }
    }
    
    func get(for key: String) -> UIImage? {
        queue.sync {
            return cache.object(forKey: key as NSString)
        }
    }
    
    func clear() {
        queue.async {
            self.cache.removeAllObjects()
        }
    }
} 