//
//  SourceModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit
// Struct for parsing initial url response
struct SourceResponse: Decodable {
    var status: String
    var sources: [NewsSource]
}

// represents the abbreviated source object that is to be parsed from an article
struct ParseableNewsSource: Decodable {
    var name:String
    var id: String
}

// the data type displayed in sources table view.
class NewsSource: Decodable, NewsItem {
    var name: String
    var description: String?
    var url: String
    var category: String
    var id: String = ""
}
