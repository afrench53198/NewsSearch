//
//  HomeViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.


import UIKit
protocol PopupViewDelegate  {
    func closeButtonPressed()
    func websiteButtonPressed()
    func articlesButtonPressed()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sourceSegmentedControl: UISegmentedControl!
    
    var viewModel: NewsViewModel!
    var newsSearchController: NewsSearchController!
    weak var tableView: NewsTableView?
    var tableViewFrame: CGRect! {
        didSet {
            tableView?.frame = tableViewFrame
        }
    }
    var popupView: NewsPopUpView?
    var currentCategories: [Category]? = []
    var backgroundView: UIView?
    let sharedNetworker = NetworkManager()
    
    // This property is used to track the source that would be passed to a new controller
    var selectedSource: NewsSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setupViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Handles segue to ArticlesVC
        if segue.identifier == Identifier.ViewController.segueToArticles.rawValue {
            if let destinationVC = segue.destination as? ArticlesViewController {
                //Passes the selected source to the view controller to be used in the network call to get articles for the given source
                destinationVC.source = selectedSource
            }
        }
            // Handles segue to NewsWebVC
        else if segue.identifier == Identifier.ViewController.segueToNewsWebVC.rawValue {
            if let destinationVC = segue.destination as? NewsWebViewController {
                //Passes the selected source to the view controller to be used in the network call to get articles for the given source
                destinationVC.urlString = selectedSource?.url
            }
        }
    }
    /// Function to layout the views after rotation or another change in orientation
    func setupViews() {
        let controlSize = CGSize(width: self.view.frame.width, height: 32)
        let sourceFrame = UIView.ViewLayout(withFrame: self.view, position: .bottomCenter, size: controlSize, padding: 0).makeLayout()
        sourceSegmentedControl?.frame = sourceFrame
        
        tableViewFrame = CGRect(x: self.view.bounds.origin.x, y: self.view.frame.minY + 68, width: self.view.bounds.width, height: self.view.frame.height - 100)
        
        
        let barFrame = CGRect(x:self.view.frame.origin.x, y: self.view.frame.origin.y + 20  , width: self.view.frame.width, height: 48)
        newsSearchController.customSearchBar.frame = barFrame
        
        let viewFrame = UIView.ViewLayout(withBounds: self.view, position: .topCenter, size: CGSize(width: self.view.bounds.width, height: 400), padding:68).makeLayout()
        popupView?.frame = viewFrame
        
        backgroundView?.frame = self.view.frame
    }
    
    private func configure() {
        navigationController?.isNavigationBarHidden = true
        configureTableViewAndViewModel(with: .NewsSourceCell)
        configureSegmentedControl()
        configureSearchController()
    }
    
    private func configureSegmentedControl() {
        let items: [String] = ["Sources", "Articles"]
        let controlSize = CGSize(width: self.view.frame.width, height: 32)
        let sourceFrame = UIView.ViewLayout(withFrame: self.view, position: .bottomCenter, size: controlSize, padding:0).makeLayout()
        let control = UISegmentedControl.makeControl(color: .black, items: items, frame: sourceFrame, action: nil)
        control.addTarget(self, action: #selector(sourceControlValueChanged(_:)), for: .valueChanged)
        control.backgroundColor = .white
        sourceSegmentedControl = control
        self.view.addSubview(sourceSegmentedControl)
    }
    /// Sets attributes and delegates to table view, and initializes the viewModel with the table view
    private func configureTableViewAndViewModel(with cell: Identifier.TableViewCell){
        tableViewFrame = CGRect(x: self.view.bounds.origin.x, y: self.view.frame.minY + 74, width: self.view.bounds.width, height: self.view.frame.height - 100)
        var newsTableView = NewsTableView(frame: tableViewFrame, style: .plain, type: cell)
        self.tableView = newsTableView
        newsTableView.delegate = self
        viewModel = NewsSourceViewModel(with: sharedNetworker, tableView: newsTableView)
        self.view.addSubview(newsTableView)
    }
    
    private func configureSearchController() {
        
        let barFrame = CGRect(x:self.view.frame.origin.x, y: self.view.frame.origin.y + 20  , width: self.view.frame.width, height: 48)
        
        newsSearchController = NewsSearchController(searchResultsController: nil, frame: barFrame, font: UIFont.systemFont(ofSize: 16), textColor: .white, bgColor: .black)
        newsSearchController.customSearchBar.placeholder = "Search Your Sources!"
        newsSearchController.customDelegate = self
        newsSearchController.customSearchBar.scopeButtonTitles = ["all", Category.sport.rawValue,"Breaking News",Category.entertainment.rawValue,"science"]
        self.view.addSubview(newsSearchController.customSearchBar)
    }
    
    @objc func sourceControlValueChanged(_ sender: UISegmentedControl!) {
        //TODO: - switch tableview data source and perform network call to get articles
        tableView?.removeFromSuperview()
        let articlesTableView = NewsTableView(frame: tableViewFrame, style: .plain, type: .ArticleCell)
        print("Value Changed")
        viewModel = ArticlesViewModel(with: sharedNetworker, tableView: articlesTableView)
        tableView = articlesTableView
        self.view.addSubview(articlesTableView)
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
            viewModel.filterData(with: text)
        }
    }
    func didTapOnCancelButton() {
        self.newsSearchController.toggleShadowAndScopeBar()
        adjustTableView(-)
        viewModel.refreshData(with: currentCategories ?? nil)
    }
    
    func didChangeSearchText(searchText: String) {
        if searchText.isEmpty {
            viewModel.refreshData(with: currentCategories ?? nil)
            print("sear")
        }
        viewModel.filterData(with: searchText)
    
    }
    
    func scopeBarIndexDidChange(to index: Int) {
        
        switch index {
        case 0: viewModel.refreshData(with: nil)
        currentCategories = nil
        case 1: viewModel.filterData(with: [Category.sport])
        currentCategories = [Category.sport]
        case 2: viewModel.filterData(with: [Category.business,Category.general,Category.politics])
        currentCategories = [Category.business,Category.general,Category.politics]
        case 3: viewModel.filterData(with: [Category.entertainment,Category.gaming,Category.music])
        currentCategories = [Category.entertainment,Category.gaming,Category.music]
        case 4: viewModel.filterData(with: [Category.technology,Category.scienceAndNature, Category.healthAndMedical])
        currentCategories = [Category.technology,Category.scienceAndNature, Category.healthAndMedical]
        default:
            print("Out of range ")
        }
    }
    
    
}
// MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewFrame = UIView.ViewLayout(withBounds: self.view, position: .center, size: CGSize(width: self.view.bounds.width, height: 400), padding:0).makeLayout()
        let data = viewModel.returnData(at: indexPath.row)
        popupView = NewsPopUpView(with: data, frame: viewFrame)
        popupView?.delegate = self
        backgroundView = UIView(frame: self.view.frame)
        backgroundView?.backgroundColor = .gray
        backgroundView?.alpha = 0.7
        if let view = popupView, let bg = backgroundView {
            self.view.addSubview(bg)
            self.view.addSubview(view)
            self.navigationItem.title = popupView!.source.name
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
    }
}

extension HomeViewController: PopupViewDelegate {
    
    func closeButtonPressed() {
        animateOutPopupView()
        selectedSource = nil
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.backgroundView?.removeFromSuperview()
    }
    func websiteButtonPressed() {
        performSegue(withIdentifier: Identifier.ViewController.segueToNewsWebVC.rawValue, sender: self)
    }
    func articlesButtonPressed() {
        performSegue(withIdentifier: Identifier.ViewController.segueToArticles.rawValue, sender: self)
    }
    
    private func animateOutPopupView() {
        let thisLayer = self.popupView?.layer
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = 5
        animation.toValue = 500
        
        let animation2 = CABasicAnimation(keyPath: "shadowOpacity")
        animation2.fromValue = 1
        animation2.toValue = 0
        
        let group = CAAnimationGroup()
        group.animations = [animation,animation2]
        group.duration = 0.25
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        group.autoreverses = false
        group.isRemovedOnCompletion = true
        group.delegate = self.popupView
        thisLayer?.add(group, forKey: "animations")
    }
}








