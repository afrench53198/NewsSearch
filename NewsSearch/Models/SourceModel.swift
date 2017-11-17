//
//  SourceModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit
// Struct for parsing initial response
struct SourceResponse: Decodable {
    var status: String
    var sources: [NewsSource]
}

// Struct that is displayed in table view. 
struct NewsSource: Decodable {

    var name: String
    var description: String
    var url: String
    var category: String
    var id: String

}
