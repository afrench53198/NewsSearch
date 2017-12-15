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
    var articles: [NewsArticle]
}


class NewsArticle: Codable, NewsItem  {
    var author: String? = ""
    var title: String? = ""
    var description: String?
    var url: String = ""
    var urlToImage: String? = ""
    var publishedAt: String? = ""
    var source: ParseableNewsSource = ParseableNewsSource(name: "", id: "")
}
