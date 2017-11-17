//
//  ArticlesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 11/12/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class ArticlesViewModel: NSObject {
    
    var networker: NewsNetworker
    var view: ArticlesTableView
    var articles: [NewsArticle] = [] {
        didSet {
            view.reloadData()
        }
    }
    var source: NewsSource
    
    init(with networker: NetworkManager, tableView: ArticlesTableView, source: NewsSource) {
        self.networker = networker
        self.view = tableView
        self.source = source
        super.init()
        view.dataSource = self
        getArticles(with: source)
    }
    func getArticles(with source: NewsSource) {
        networker.getArticlesForSource(with: source) { (articles) in
        self.articles = articles
        }
    }
    
}
extension ArticlesViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view.dequeueReusableCell(withIdentifier: Identifier.TableViewCell.ArticleCell.rawValue, for: indexPath) as! ArticleCell
        
        let article = articles[indexPath.row]
        cell.configure(with: article)
        
        return cell
    }
    
    
}
