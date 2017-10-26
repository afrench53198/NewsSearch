//
//  Identifiers.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit


enum Identifier: String {
    case NewsCell
    case NewsSourceCell
}

extension UITableView {
    
    func registerNib(name:Identifier) {
        let nib = UINib(nibName: name.rawValue, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name.rawValue)
    }
    
    
    
    
}
