//
//  ArticleModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

struct ArticleResponse: Decodable  {
    var status: String
    var sortBy: String
    var source: String
    var articles: [NewsArticle]
}



struct NewsArticle: Decodable  {
    var author: String?
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String?
}
