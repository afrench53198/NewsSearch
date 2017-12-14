//
//  UIImageCaching .swift
//  NewsSearch
//
//  Created by Adam B French on 12/13/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject,AnyObject>()

extension UIImageView {
    func downloadFromLink(_ url: String) {
        guard let thisUrl = URL(string: url) else {self.image = #imageLiteral(resourceName: "close") ;return}
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                    self.image = imageFromCache
            }
        }
      
        let session = URLSession.shared.dataTask(with: thisUrl) { (data, response, error) in
            if error != nil {
                self.image = #imageLiteral(resourceName: "close")
                return
            }
            guard let thisData = data else {self.image = #imageLiteral(resourceName: "close");return}
            guard let image = UIImage(data: thisData) else {
                DispatchQueue.main.async {
                    self.image = #imageLiteral(resourceName: "close")
                }
                return
            }
            DispatchQueue.main.async {
                self.image = image
                imageCache.setObject(image, forKey: url as AnyObject)
            }
          
        }
        session.resume()
    }
    
    
}
