//
//  HomeViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.


import UIKit
// TODO: - Refactor controller so creation of view models is moved to viewModelManager
protocol PopupViewDelegate  {
    func closeButtonPressed()
    func websiteButtonPressed()
    func articlesButtonPressed()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sourceSegmentedControl: UISegmentedControl!
    
    var viewModel: NewsSourceViewModel!
    var newsSearchController: NewsSearchController!
    weak var tableView: NewsTableView?
    var tableViewFrame: CGRect! {
        didSet {
            tableView?.frame = tableViewFrame
        }
    }
    var popupView: NewsPopupView?
    // Used by View Model to set current data for search
    var currentCategories: [Category]? = nil
    var backgroundView = UIView()
    let sharedNetworker = NetworkManager()
    
    // This property is used to track the source that would be passed to a new controller
    var selectedSource: NewsSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.title = "Home"
    }
    
    private func configure() {
        navigationController?.isNavigationBarHidden = true
        configureTableViewAndViewModel(with: .NewsSourceCell)
        configureSearchController()
    
    }
    /// Sets attributes and delegates to table view, and initializes the viewModel with the table view
    private func configureTableViewAndViewModel(with cell: Identifier.TableViewCell){
        tableViewFrame = UIView.ViewLayout(withBounds: self.view, position: .center, size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 100), padding: (20,0)).makeInnerLayout()
        let newsTableView = NewsTableView(frame: tableViewFrame, style: .plain, type: cell)
        self.tableView = newsTableView
        newsTableView.delegate = self
        viewModel = NewsSourceViewModel(with: sharedNetworker, tableView: newsTableView)
        self.view.addSubview(newsTableView)
    }
    
    private func configureSearchController() {
        
        let barFrame = CGRect(x:self.view.frame.origin.x, y: self.view.frame.origin.y + 20  , width: self.view.frame.width, height: 48)
        
        newsSearchController = NewsSearchController(searchResultsController: nil, frame: barFrame, font: UIFont.systemFont(ofSize: 16), textColor: .white, bgColor: .black)
        newsSearchController.customSearchBar.placeholder = "Search Your Sources!"
        newsSearchController.customSearchBar.scopeButtonTitles = ["all", Category.sport.rawValue,"Breaking News",Category.entertainment.rawValue,"science"]
        newsSearchController.customDelegate = self
        self.view.addSubview(newsSearchController.customSearchBar)
    }
    
    private func adjustTableView(_ operation: @escaping ((Int,Int) -> (Int))) {
        let int1 = Int((tableView?.frame.y)!)
        let int2 = 48
        UIView.animate(withDuration: 0.4, animations: {
            self.tableView?.frame.y = CGFloat(operation(int1,int2))
        }, completion: nil)
    }
    
}


// MARK: - Custom Search Delegate
extension HomeViewController: CustomSearchControllerDelegate {
    
    func didStartSearching() {
        self.newsSearchController.toggleShadowAndScopeBar()
        adjustTableView(+)
   
    }
    
    func didTapOnSearchButton() {
        if let text = newsSearchController.customSearchBar.text {
            viewModel.filterData(text,currentCategories)
        }
    }
    
    func didTapOnCancelButton() {
        self.newsSearchController.toggleShadowAndScopeBar()
        adjustTableView(-)
        self.newsSearchController.customSearchBar.text?.removeAll(keepingCapacity: false)
        viewModel.refreshData(with: currentCategories)
        print(viewModel.currentData.count)
    }
    
    func didChangeSearchText(searchText: String) {
        if searchText.count <= 0 {
            viewModel.refreshData(with: currentCategories)
        } else {
            viewModel.filterData(searchText,currentCategories)
        }
    }
    
    func scopeBarIndexDidChange(to index: Int) {
        switch index {
        case 0: viewModel.refreshData(with: nil)
        currentCategories = nil
        case 1: viewModel.refreshData(with: [Category.sport])
        currentCategories = [Category.sport]
        case 2: viewModel.refreshData(with: [Category.business,Category.general,Category.politics])
        currentCategories = [Category.business,Category.general,Category.politics]
        case 3: viewModel.refreshData(with: [Category.entertainment,Category.gaming,Category.music])
        currentCategories = [Category.entertainment,Category.gaming,Category.music]
        case 4: viewModel.refreshData(with: [Category.technology,Category.scienceAndNature, Category.healthAndMedical] )
        currentCategories = [Category.technology,Category.scienceAndNature, Category.healthAndMedical]
        default:
            print("Out of range ")
        }
    }
}

// MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewFrame = UIView.ViewLayout(withBounds: self.view, position: .center, size: CGSize(width: self.view.bounds.width, height: 400), padding:(0,0)).makeInnerLayout()
        let data = viewModel.returnData(at: indexPath.row)
        selectedSource = data as? NewsSource
        popupView = SourcePopupView(with: data, frame: viewFrame)
        popupView?.delegate = self
        backgroundView.backgroundColor = .white
        backgroundView.frame = self.view.frame
        backgroundView.alpha = 0.7
        if let popup = popupView as? UIView{
            self.view.addSubview(backgroundView)
            self.view.addSubview(popup)
            self.navigationItem.title = data.name
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}


extension HomeViewController: PopupViewDelegate, CAAnimationDelegate {
    
    func closeButtonPressed() {
        guard let popup = popupView as? SourcePopupView else {return}
        popup.animateOut()
        selectedSource = nil
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.backgroundView.removeFromSuperview()
    }
    func websiteButtonPressed() {
        guard let source = selectedSource else {return}
        let viewController = NewsWebViewController(source)
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true, completion: nil)
    }
    
    func articlesButtonPressed() {
        var viewController = ArticlesViewController(selectedSource)
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true, completion: nil)
    }
}







