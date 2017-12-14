//
//  NewsItem.swift
//  NewsSearch
//
//  Created by Adam B French on 11/28/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import Foundation

// Abstraction of News Article and Source
@objc protocol NewsItem {
    @objc optional var name: String {get}
    var description: String? {get}
    var url: String {get}
    @objc optional var urlToImage: String? {get}
    @objc optional var category: String {get}
    @objc optional var title: String? {get}
    @objc optional var publishedAt: String? {get}
    @objc optional var author: String? {get}
}


