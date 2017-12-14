//
//  SourcesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//


import UIKit

class NewsSourceViewModel: NSObject {
    
    var storedData: [NewsItem] = []
    var currentData: [NewsItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadSections([0], with: .bottom)
            }
        }
    }
    var filteredData: [NewsItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadSections([0], with: .bottom)
            }
        }
    }
    var searchController: NewsSearchController?
    var networker: NewsNetworker
    var view: UITableView
    
    
    init(with networker: NewsNetworker, tableView: UITableView) {
        self.networker = networker
        self.view = tableView
        super.init()
        view.dataSource = self
        if storedData.isEmpty {
            getData()
        }
    }
    /// View model returns appropriate data for use in the View controller 
    func returnData(at index: Int) -> NewsItem  {
        return currentData[index]
    }
    
    func getData() -> ()  {
        networker.getSourcesFromNetwork { [weak self] (sources) in
            self?.storedData = sources
            self?.currentData = sources
        }
        
    }
    /// Filters data with search text and provides the array of sources depending on the filter state
    func filterData(_ query: String, _ categories: [Category]?) {
        if query.isEmpty {
            refreshData(with: categories)
        }
        
        guard let filter = categories else
        // Filters data with no categories, only the search query
        {
            currentData = currentData.filter {
                guard let thisName = $0.name else {return false}
                return thisName.localizedCaseInsensitiveContains(query) || ($0.category?.localizedCaseInsensitiveContains(query))!
            }
            return
        }
        // Uses refreshData to filter sources with appropriate categories then filters sources with query
        refreshData(with: filter)
        currentData = currentData.filter {
            guard let thisName = $0.name else {return false}
            return thisName.localizedCaseInsensitiveContains(query) || ($0.category?.localizedCaseInsensitiveContains(query))!
        }
    }
    
    func refreshData(with categories: [Category]?)  {
        var returnArray: [NewsItem] = []
        guard let filters = categories else {currentData = storedData; return}

        for i in filters {
            returnArray += storedData.filter({ (item) -> Bool in
                guard let thisCategory = item.category else {return false}
                return thisCategory == i.rawValue
            })
        }
        currentData = returnArray
    }
    
}
// MARK: - TableViewDataSource
extension NewsSourceViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view.dequeueReusableCell(withIdentifier: Identifier.TableViewCell.NewsSourceCell.rawValue) as! NewsSourceCell
        let source = currentData[indexPath.row] as! NewsSource
        cell.configure(with: source)
        return cell
    }
}




