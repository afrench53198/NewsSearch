//
//  SourcesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//


import UIKit
enum FilterState: Int {
    case unfiltered
    case filtered
}

protocol NewsViewModel: class {
    
    var networker: NewsNetworker {get}
    var currentData: [NewsItem] {get set}
    
    func filterData(with category: [Category])
    func filterData(with query:String)
    func getData()
    /// Replenishes the news items from stored data after search
    func refreshData(with categories: [Category]?)
    func returnData(at index: Int) -> NewsItem
    
}

class NewsSourceViewModel: NSObject, NewsViewModel {
    
    
    var storedData: [NewsItem] = []  {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    var currentData: [NewsItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    var categorizedData: [Category:[NewsItem]] = [:]
    var networker: NewsNetworker
    var view: NewsTableView
    var filterState = FilterState.unfiltered
 
    init(with networker: NetworkManager, tableView: NewsTableView) {
        self.networker = networker
        self.view = tableView
        super.init()
        view.dataSource = self
        getData()
        
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
        categorizeData()
    }
    /// Filters data with search text and provides the array of sources depending on the filter state
    func filterData(with query: String) {
        if query.isEmpty {
            return
        }
        switch filterState {
        case .unfiltered:
            currentData = storedData.filter {
                guard let thisName = $0.name else {return false}
                return thisName.localizedCaseInsensitiveContains(query) || ($0.category?.localizedCaseInsensitiveContains(query))!
            }
        default:
            currentData = currentData.filter {
                guard let thisName = $0.name else {return false}
                return thisName.localizedCaseInsensitiveContains(query) || ($0.category?.localizedCaseInsensitiveContains(query))!
            }
        }
        
    }
    
    func filterData(with categories: [Category])  {
        filterState = .filtered
        var returnArray: [NewsItem] = []
        for i in categories {
            returnArray += storedData.filter({ (item) -> Bool in
                guard let thisCategory = item.category else {return false}
                return thisCategory == i.rawValue
            })
        }
        currentData = returnArray
    }

    func refreshData(with categories: [Category]?) {
        categories != nil ? filterData(with: categories!) : setData()
    }
   
    func categorizeData() {
        categorizedData[.business] = storedData.filter({ (item) -> Bool in
           return item.category! == Category.business.rawValue
        })
        categorizedData[.entertainment] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.entertainment.rawValue
        })
        categorizedData[.gaming] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.gaming.rawValue
        })
        categorizedData[.healthAndMedical] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.healthAndMedical.rawValue
        })
        categorizedData[.scienceAndNature] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.scienceAndNature.rawValue
        })
        categorizedData[.general] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.general.rawValue
        })
        categorizedData[.politics] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.politics.rawValue
        })
        categorizedData[.sport] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.sport.rawValue
        })
        categorizedData[.technology] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.technology.rawValue
        })
        categorizedData[.music] = storedData.filter({ (item) -> Bool in
            return item.category! == Category.music.rawValue
        })
    }
/// Refills the current data property with the stored data gathered in initial networking call
    private func setData() {
        filterState = .unfiltered
        currentData = storedData
    }
}
// MARK: - TableViewDataSource
extension NewsSourceViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view.dequeueReusableCell(withIdentifier: Identifier.TableViewCell.NewsSourceCell.rawValue) as! NewsSourceCell
        
        if let source = currentData[indexPath.row] as? NewsSource {
            cell.configure(with: source)
            return cell
        }
        
        return UITableViewCell()
    }
    
}

