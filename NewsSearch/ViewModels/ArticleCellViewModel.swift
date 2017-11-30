//
//  ArticleCellViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 11/28/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

struct ArticleViewModel {
    let source: String
    let imageUrl: String?
    let title: String
    let author: String?
    let datePublished: String?
    let description: String?
    
    init(article: NewsArticle) {
        source = article.source.name
        imageUrl = article.urlToImage
        title = article.title
        author = article.author
        datePublished = article.publishedAt
        description = article.description
    }
    
}
