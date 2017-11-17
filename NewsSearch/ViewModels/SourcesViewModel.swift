//
//  SourcesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//


import UIKit

class NewsSourceViewModel: NSObject {
    
    var networker: NetworkManager
    var view: NewsTableView
    var filterState: FilterState = .unfiltered
    var sources: [NewsSource] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    var categorizedSources: [NewsSource] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    var filteredSources: [NewsSource] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.reloadData()
            }
        }
    }
    
    init(with networker: NetworkManager, tableView: NewsTableView) {
        self.networker = networker
        self.view = tableView
        super.init()
        view.dataSource = self
        getData()
    }
    
    func getData() -> ()  {
        self.filterState = .unfiltered
        networker.getSourcesFromNetwork { [weak self] (sources) in
            self?.sources = sources
        }
    }
    /// Filters data with search text and provides the array of sources depending on the filter state 
    func filterData(with input: String) {
        switch filterState {
        case .unfiltered:
            filterState = .filtered
            filteredSources = sources.filter {
                return $0.name.localizedCaseInsensitiveContains(input)
            }
        case .filtered:
            filteredSources = filteredSources.filter{
                 return $0.name.localizedCaseInsensitiveContains(input)
            }
        default:
            filterState = .filteredAndCategorized
            filteredSources = categorizedSources.filter {
                return $0.name.localizedCaseInsensitiveContains(input)
            }
        }
    }
    
    func filterSourcesWithCategories(categories: [SourceCategory]) {
        var returnArray: [NewsSource] = []
        switch filterState {
        case .unfiltered :
            filterState = .categorized
            for i in categories {
                returnArray += sources.filter {
                   return $0.category == i.rawValue
                }
                categorizedSources = returnArray
            }
        case .filtered :
            filterState = .filteredAndCategorized
            for i in categories {
                returnArray += sources.filter {
                    return $0.category == i.rawValue
                }
                filteredSources = returnArray
            }
        default:
            filterState = .categorized
            for i in categories {
                returnArray += sources.filter {
                    return $0.category == i.rawValue
                }
                categorizedSources = returnArray
            }
        }
    }
}

// MARK: - TableViewDataSource
extension NewsSourceViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterState {
        case .unfiltered:
            return sources.count
        case .categorized:
            return categorizedSources.count
        default:
            return filteredSources.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view.dequeueReusableCell(withIdentifier: Identifier.TableViewCell.NewsSourceCell.rawValue) as! NewsSourceCell
        switch filterState {
        case .unfiltered:
            let source = sources[indexPath.row]
            cell.configure(with: source)
            return cell
        case .categorized:
            let source = categorizedSources[indexPath.row]
            cell.configure(with: source)
            return cell
        default:
            let source = filteredSources[indexPath.row]
            cell.configure(with: source)
            return cell
        }
    }
}

    extension NewsSourceViewModel {
    enum FilterState {
        case unfiltered
        case filtered
        case filteredAndCategorized
        case categorized
    }
}


