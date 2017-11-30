//
//  NewsWebView.swift
//  NewsSearch
//
//  Created by Adam B French on 11/16/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit
import WebKit

class NewsWebView: WKWebView {

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
