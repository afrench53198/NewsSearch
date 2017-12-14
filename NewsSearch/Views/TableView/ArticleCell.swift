//
//  ArticleCell.swift
//  NewsSearch
//
//  Created by Adam B French on 11/10/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleCell: UITableViewCell {
    

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    

    func configure(with article: NewsArticle) {
        titleLabel.text = article.title
        articleDescription.text = article.description
        authorLabel.text = article.author
        guard let date = article.publishedAt else {return}
        datePublished.text = date.dateFromTimestamp?.relativelyFormatted(short: true)
        guard let urlString = article.urlToImage else {articleImageView.image = #imageLiteral(resourceName: "close");return}
        guard let url = URL(string: urlString) else {articleImageView.image = #imageLiteral(resourceName: "close");return}
        articleImageView.sd_setImage(with: url)
    }
}
