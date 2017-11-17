//
//  Identifiers.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit


enum Identifier {
  
    enum TableViewCell:String {
        case ArticleCell
        case NewsSourceCell
    }
    enum ViewController:String {
        case ArticlesController
        case ToArticles
    }
   
}
// This Enum is mainly for avoiding typos by using string literals to create URLs in the NetworkManager class. It also allows easy modification and extension.
enum NewsAPI: String {
    
    case articles
    case sources
   // This nested enum is used to create URLQueryItems when a network request is sent to get articles.
    enum SortBy: String {
        case top
        case latest
        case popular
        var query: URLQueryItem {
            switch self {
            case .latest:
                return URLQueryItem(name: self.rawValue, value: "sortBy")
            case .popular:
                return URLQueryItem(name: self.rawValue, value: "sortBy")
            case .top:
                return URLQueryItem(name: self.rawValue, value: "sortBy")
            }
        }
    }
    
    var scheme: String {
        return "https"
    }
    var host: String {
        return "newsapi.org"
    }
    var path: String {
        switch self {
        case .articles:
            return "/v1/articles"
        case .sources:
            return "/v1/sources"
        }
    }
   
    var key: URLQueryItem {
        return URLQueryItem(name: "apiKey", value: "925668bfe44c42dcb70474c065e09b79")
    }
}







