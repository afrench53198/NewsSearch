//
//  ArticlesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 11/12/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class ArticlesTableViewModel: NSObject {
  
    var networker: NewsNetworker
    var view: UITableView
    var storedData: [NewsArticle] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    var currentData: [NewsItem] = [] {
        didSet {
            self.view.reloadData()
        }
    }
    var source: NewsSource!

    init(with networker:NewsNetworker, tableView: UITableView, source: NewsSource) {
        self.networker = networker
        self.view = tableView
        self.source = source
        super.init()
        view.dataSource = self
        getData(for: source)
        
    }
    
    init(with networker: NewsNetworker, tableView: UITableView) {
        self.networker = networker
        self.view = tableView
        super.init()
        view.dataSource = self
        getData()
    }
    
    func getData() {
        networker.getArticles(with: nil) {[weak self] (articles) in
            guard let strongSelf = self else {return}
            strongSelf.storedData = articles
            strongSelf.currentData = strongSelf.storedData
        }
    }
   
    func filterData(with query: String)
    {
       currentData = storedData.filter({ (article) -> Bool in
                guard let thisDescription = article.description else {return false}
                guard let thisTitle = article.title else {return false}
                return thisTitle.localizedCaseInsensitiveContains(query) || thisDescription.localizedCaseInsensitiveContains(query) })
    }
    func filterData(with category: [Category]) {
        currentData = storedData.filter({ (article) -> Bool in
            for i in category {
                return doesMatchQuery(string: article.description, query: i.rawValue) || doesMatchQuery(string: article.title, query: i.rawValue)
            }
            return false
        })
    }
    func getData(for: NewsSource) {
        let sourceArray = [source]
        networker.getArticles(with: sourceArray as? [NewsSource]) { (responseArticles) in
            self.currentData = responseArticles
            print(responseArticles.count)
        }
    }
    func refreshData() {
        print("")
    }
    
    func returnData(at index: Int) -> NewsItem {
        return currentData[index]
    }
    func refreshData(with categories: [Category]?) {
        print("")
    }
    private func doesMatchQuery(string: String?, query: String) -> Bool {
        guard let thisString = string else {return false}
        return thisString.localizedCaseInsensitiveContains(query)
    }
    
}
extension ArticlesTableViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view.dequeueReusableCell(withIdentifier: Identifier.TableViewCell.ArticleCell.rawValue) as! ArticleCell
       if let data = currentData[indexPath.row] as? NewsArticle {
            cell.configure(with: data)
            return cell
        }
        fatalError("News article Data failure"); return UITableViewCell()
    }
}



