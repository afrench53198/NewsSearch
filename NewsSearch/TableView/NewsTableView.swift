//
//  NewsTableView.swift
//  NewsSearch
//
//  Created by Adam B French on 10/24/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class NewsTableView: UITableView {
   
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

  private func configure() {
        registerNib(name: .NewsSourceCell)
    
}
}

