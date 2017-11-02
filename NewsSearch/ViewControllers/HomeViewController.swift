//
//  HomeViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.


import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sourceSegmentedControl: UISegmentedControl!
    
    let networker = SourcesNetworkManager()
    var viewModel: NewsSourceViewModel!
    var newsSearchController: NewsSearchController!
    var tableView: NewsTableView!
    var lastYContentOffset: CGFloat!

    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    override func viewDidLayoutSubviews() {
        setupViews()
    }
    /// Function to layout the views after rotation or another change in orientation
    func setupViews() {
        let controlSize = CGSize(width: self.view.frame.width, height: 32)
        let sourceFrame = UIView.ViewLayout(withFrame: self.view, position: .bottomCenter, size: controlSize, padding: 0).makeLayout()
        sourceSegmentedControl?.frame = sourceFrame
        
        let tableViewFrame = CGRect(x: self.view.bounds.origin.x, y: self.view.frame.minY + 68, width: self.view.bounds.width, height: self.view.frame.height - 100)
        tableView.frame = tableViewFrame
        
        let barFrame = CGRect(x:self.view.frame.origin.x, y: self.view.frame.origin.y + 20  , width: self.view.frame.width, height: 48)
        newsSearchController.customSearchBar.frame = barFrame
        
    }
    
    func configure() {
        
        configureSegmentedControl()
        configureTableView()
        viewModel = NewsSourceViewModel(with: networker,tableView: tableView)
        configureSearchController()
    }
    
    func configureSegmentedControl() {
        let items: [String] = ["all", SourceCategory.sport.rawValue,"Breaking News",SourceCategory.entertainment.rawValue,"science"]
        let controlSize = CGSize(width: self.view.frame.width, height: 32)
        let sourceFrame = UIView.ViewLayout(withFrame: self.view, position: .bottomCenter, size: controlSize, padding:0).makeLayout()
        let control = UISegmentedControl.makeControl(color: .black, items: items, frame: sourceFrame, action: nil)
        control.addTarget(self, action: #selector(sourceControlValueChanged(_:)), for: .valueChanged)
        sourceSegmentedControl = control
        self.view.addSubview(sourceSegmentedControl)
    }
    
    func configureTableView(){
        let tableViewFrame = CGRect(x: self.view.bounds.origin.x, y: self.view.frame.minY + 48, width: self.view.bounds.width, height: self.view.frame.height - 100)
        tableView = NewsTableView(frame: tableViewFrame, style: .plain)
        tableView.layoutMargins = UIEdgeInsetsMake(0, 8, 0, 8)
        tableView.delegate = self
 
        self.view.addSubview(self.tableView)
        
    }
    
    
    func configureSearchController() {
        
        let barFrame = CGRect(x:self.view.frame.origin.x, y: self.view.frame.origin.y + 20  , width: self.view.frame.width, height: 48)
        
        newsSearchController = NewsSearchController(searchResultsController: nil, frame: barFrame, font: UIFont.systemFont(ofSize: 16), textColor: .white, bgColor: .black)
        newsSearchController.customSearchBar.placeholder = "Search Your Sources!"
        newsSearchController.customDelegate = self
        
        self.view.addSubview(newsSearchController.customSearchBar)
        
    }
    
    @objc func sourceControlValueChanged(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.getData()
        case 1: viewModel.getSourcesWithCategories(categories: [SourceCategory.sport])
        case 2: viewModel.getSourcesWithCategories(categories: [SourceCategory.business,SourceCategory.general,SourceCategory.politics])
        case 3: viewModel.getSourcesWithCategories(categories: [SourceCategory.entertainment,SourceCategory.gaming,SourceCategory.music])
        case 4: viewModel.getSourcesWithCategories(categories: [SourceCategory.technology,SourceCategory.scienceAndNature])
        default:
            print("Out of range ")
        }
    }
}

// MARK: - Custom Search Delegate
extension HomeViewController: CustomSearchControllerDelegate {
    func didStartSearching() {
        UIView.animate(withDuration: 1) {
            self.newsSearchController.customSearchBar.toggleShadow()
        }
        
    }
    
    func didTapOnSearchButton() {
        if !viewModel.shouldShowResults {
            viewModel.shouldShowResults = true
            tableView.reloadData()
        }

    }
    
    func didTapOnCancelButton() {
        viewModel.shouldShowResults = false
        tableView.reloadData()
        UIView.animate(withDuration: 5) {
            self.newsSearchController.customSearchBar.toggleShadow()
        }
    
    }
    
    
    func didChangeSearchText(searchText: String) {
        if searchText .isEmpty {
            tableView.reloadData()
            
        } else {
            viewModel.shouldShowResults = true
            viewModel.filterData(with: searchText)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source = viewModel.sources[indexPath.row]
        let viewFrame = UIView.ViewLayout(withBounds: self.view, position: .center, size: CGSize(width: 300, height: 400), padding: 0).makeLayout()
        let popUpView = NewsPopUpView(with: source, frame: viewFrame)
        self.view.addSubview(popUpView)
    }
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */






