//
//  ArticleCell.swift
//  NewsSearch
//
//  Created by Adam B French on 11/10/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var articleDescription: UILabel!

    override func awakeFromNib() {
        
    }

    func configure(with article: NewsArticle) {
        awakeFromNib()
        titleLabel.text = article.title
        authorLabel.text = article.author
        datePublished.text = article.publishedAt
        articleDescription.text = article.description
        setImageForView(from: article.urlToImage)
    }
    
    
   private func setImageForView(from url:String) {
        getDataForImage(with: url) { (image) in
            self.articleImageView.image = image
        }
    }
    
    private func getDataForImage (with string: String, completion: @escaping (UIImage) -> () ) {
        guard let thisUrl = URL(string: string) else {print("invalid url for image in article cell configuration"); return}
        let session = URLSession(configuration: .default)
      // Run the task on the global queue as not to overload the main queue 
        DispatchQueue.global().async {
            let task = session.dataTask(with: thisUrl) { (data, response, error) in
                guard error == nil else {print(error!.localizedDescription); return}
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        // Set the image with the completion handler on the main queue
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    } else {print("couldn't parse image from data")}
                } else {print("No data from task in Article Cell")}
            }
            task.resume()
        }
    }
}
