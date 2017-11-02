//
//  SourcesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//


import UIKit

class NewsSourceViewModel: NSObject {
    
    var networker: SourcesNetworkManager
    var view: NewsTableView
    var shouldShowResults = false
    var sources: [NewsSource] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    var filteredSources: [NewsSource] = []
    
    init(with networker: SourcesNetworkManager, tableView: NewsTableView) {
        self.networker = networker
        self.view = tableView
        super.init()
        
        view.dataSource = self
        getData()
    }
    
    func getData() -> ()  {
        networker.getSourcesFromNetwork { [weak self] (sources) in
            self?.sources = sources
            DispatchQueue.main.async {
                self?.view.reloadData()
            }
        }
       
    }

    func filterData(with input: String) {
      
        filteredSources = sources.filter {
         return $0.name.localizedCaseInsensitiveContains(input)
        }
        shouldShowResults = true
        DispatchQueue.main.async {
            self.view.reloadData()
        }
    }
    func getSourcesWithCategories(categories: [SourceCategory]) {
        networker.getSourcesWithCategories(categories: categories) {[weak self] (sources) in
            self?.sources = sources
        }
    }
    
}

// MARK: - TableViewDataSource
extension NewsSourceViewModel: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowResults {
            return filteredSources.count
        } else {
            return sources.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view.dequeueReusableCell(withIdentifier: Identifier.NewsSourceCell.rawValue) as! NewsSourceCell
        if shouldShowResults {
            let filteredSource = filteredSources[indexPath.row]
            cell.configure(with: filteredSource)
            return cell
        }
       
        let source = sources[indexPath.row]
        cell.configure(with: source)
        return cell
    }
}


