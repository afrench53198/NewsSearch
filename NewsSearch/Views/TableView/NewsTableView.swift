//
//  NewsTableView.swift
//  NewsSearch
//
//  Created by Adam B French on 10/24/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib(name:Identifier.TableViewCell) {
        let nib = UINib(nibName: name.rawValue, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name.rawValue)
    }
}

class NewsTableView: UITableView {
    
    init(frame: CGRect, style: UITableViewStyle, type: Identifier.TableViewCell) {
        super.init(frame: frame, style: style)
        registerNib(name: type)
        self.rowHeight = 120
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

