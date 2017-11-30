//
//  ArticlesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 11/12/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class ArticlesTableViewModel: NSObject, NewsViewModel {
    func filterData(with query: String, categorized: Bool) {
        print("filter the data bihhh")
    }
    // TODO: Instantiate New articles Table view when changing segmented control in HomeVC. Do slideout and slide in animation
    var networker: NewsNetworker
    var view: NewsTableView
    var filterState: FilterState
    var storedData: [NewsArticle] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    var currentData: [NewsItem] = []
    var source: NewsSource!
    private var cellViewModels: [ArticleViewModel?] = []
    
    init(with networker: NetworkManager, tableView: NewsTableView, source: NewsSource) {
        self.networker = networker
        self.view = tableView
        self.source = source
        filterState = .filtered
        super.init()
        view.dataSource = self
        getData(for: source)
    }
    
    init(with networker: NetworkManager, tableView: NewsTableView) {
        self.networker = networker
        self.view = tableView
        self.filterState = .unfiltered
        super.init()
        view.dataSource = self
        getData()
    }
    
    
    func getData() {
        networker.getArticles(with: nil) {[weak self] (articles) in
            guard let strongSelf = self else {return}
            strongSelf.storedData = articles
            strongSelf.currentData = strongSelf.storedData
            strongSelf.cellViewModels = self.initCellViewModels(articles)
        }
    
    }
    func filterData(with query: String) {
        switch filterState {
            
        case .unfiltered:
            currentData = storedData.filter({ (article) -> Bool in
                guard let thisDescription = article.description else {return false}
                return article.title.localizedCaseInsensitiveContains(query) || thisDescription.localizedCaseInsensitiveContains(query)
            })
            filterState = .filtered
        default:
            currentData = currentData.filter({ (article) -> Bool in
                guard let thisTitle = article.title else {return false}
                guard let thisDescription = article.description else {return false}
                return thisTitle.localizedCaseInsensitiveContains(query) || thisDescription.localizedCaseInsensitiveContains(query)
            })
        }
    }
    func filterData(with category: [Category]) {
        filterState = .filtered
        currentData = storedData.filter({ (article) -> Bool in
            for i in category {
                guard let thisDescription = article.description else {return false}
                return article.title.localizedCaseInsensitiveContains(i.rawValue) || thisDescription.localizedCaseInsensitiveContains(i.rawValue)
            }
            return false
        })
    }
    func getData(for: NewsSource) {
        let sourceArray = [source]
        networker.getArticles(with: sourceArray as? [NewsSource]) { (responseArticles) in
            self.currentData = responseArticles
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
    private func initCellViewModels(_ articles:[NewsItem]) -> [ArticleViewModel?] {
        return  articles.map { (item) -> ArticleViewModel? in
            if let model = item as? NewsArticle {
                return ArticleViewModel(article: model)
            } else {
                return nil
            }
        }
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
        return UITableViewCell()
    }
}



