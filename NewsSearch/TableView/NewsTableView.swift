//
//  NewsTableView.swift
//  NewsSearch
//
//  Created by Adam B French on 10/24/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class NewsTableView: UITableView {

  
    var sources: [NewsSource] = []
   
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

  private func configure() {
        self.dataSource = self
        registerNib(name: .NewsSourceCell)
    }
}


extension NewsTableView: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: Identifier.NewsSourceCell.rawValue) as! NewsSourceCell
        let source = sources[indexPath.row]
        cell.configure(with: source)
        return cell
    }
    
    
}
