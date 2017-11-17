//
//  HomeViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.


import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var sourceSegmentedControl: UISegmentedControl!
    
    var viewModel: NewsSourceViewModel!
    var newsSearchController: NewsSearchController!
    var tableView: NewsTableView!
    var lastYContentOffset: CGFloat!
    var popupView: NewsPopUpView?
    var backgroundView: UIView?
   // This property is used to track the source that would be passed to a new controller
    var selectedSource: NewsSource?
    
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
        
        let viewFrame = UIView.ViewLayout(withBounds: self.view, position: .topCenter, size: CGSize(width: self.view.bounds.width, height: 400), padding:68).makeLayout()
        popupView?.frame = viewFrame
        
        backgroundView?.frame = self.view.frame
    }
    
    private func configure() {
        navigationController?.isNavigationBarHidden = true
        configureSegmentedControl()
        configureTableView()
        viewModel = NewsSourceViewModel(with: NetworkManager(),tableView: tableView)
        configureSearchController()
    }
    
    private func configureSegmentedControl() {
        let items: [String] = ["all", SourceCategory.sport.rawValue,"Breaking News",SourceCategory.entertainment.rawValue,"science"]
        let controlSize = CGSize(width: self.view.frame.width, height: 32)
        let sourceFrame = UIView.ViewLayout(withFrame: self.view, position: .bottomCenter, size: controlSize, padding:0).makeLayout()
        let control = UISegmentedControl.makeControl(color: .black, items: items, frame: sourceFrame, action: nil)
        control.addTarget(self, action: #selector(sourceControlValueChanged(_:)), for: .valueChanged)
        control.apportionsSegmentWidthsByContent = true
        sourceSegmentedControl = control
        self.view.addSubview(sourceSegmentedControl)
    }
    
    private func configureTableView(){
        let tableViewFrame = CGRect(x: self.view.bounds.origin.x, y: self.view.frame.minY + 48, width: self.view.bounds.width, height: self.view.frame.height - 100)
        tableView = NewsTableView(frame: tableViewFrame, style: .plain)
        tableView.layoutMargins = UIEdgeInsetsMake(0, 8, 0, 8)
        tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        
    }
    
    private func configureSearchController() {
        
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
        case 1: viewModel.filterSourcesWithCategories(categories: [SourceCategory.sport])
        case 2: viewModel.filterSourcesWithCategories(categories: [SourceCategory.business,SourceCategory.general,SourceCategory.politics])
        case 3: viewModel.filterSourcesWithCategories(categories: [SourceCategory.entertainment,SourceCategory.gaming,SourceCategory.music])
        case 4: viewModel.filterSourcesWithCategories(categories: [SourceCategory.technology,SourceCategory.scienceAndNature])
        default:
            print("Out of range ")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.ViewController.ToArticles.rawValue {
            if let destinationVC = segue.destination as? ArticlesViewController {
                print("Destination Reached ")
                //Passes the selected source to the view controller to be used in the network call to get articles for the given source
                destinationVC.source = selectedSource
            }
        }
    }
}


// MARK: - Custom Search Delegate
extension HomeViewController: CustomSearchControllerDelegate {
    
    func didStartSearching() {
        self.newsSearchController.toggleShadow()
    }
    
    func didTapOnSearchButton() {
        if let text = newsSearchController.customSearchBar.text {
            if text.characters.count != 0  {
                viewModel.filterData(with: text)
            }
        }
    }
    
    func didTapOnCancelButton() {
        switch viewModel.filterState {
        case .filteredAndCategorized:
            viewModel.filterState = .categorized
        case .filtered:
            viewModel.filterState = .unfiltered
        default:
            break
        }
        tableView.reloadData()
        self.newsSearchController.toggleShadow()
    }
    
    func didChangeSearchText(searchText: String) {
        if searchText .isEmpty && self.sourceSegmentedControl.selectedSegmentIndex > 0 {
            viewModel.filterState = .categorized
            tableView.reloadData()
        } else if searchText .isEmpty && self.sourceSegmentedControl.selectedSegmentIndex <= 0 {
            viewModel.filterState = .unfiltered
        }
        else {
            viewModel.filterData(with: searchText)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewFrame = UIView.ViewLayout(withBounds: self.view, position: .center, size: CGSize(width: self.view.bounds.width, height: 400), padding:0).makeLayout()
        
        switch viewModel.filterState {
        case .unfiltered:
            let source = viewModel.sources[indexPath.row]
            selectedSource = source
            popupView = NewsPopUpView(with: source, frame: viewFrame)
     
        case .categorized:
            let source = viewModel.categorizedSources[indexPath.row]
            selectedSource = source
            popupView = NewsPopUpView(with: source, frame: viewFrame)
          
        default:
            let source = viewModel.filteredSources[indexPath.row]
            selectedSource = source
            popupView = NewsPopUpView(with: source, frame: viewFrame)
        }
       
        popupView?.delegate = self
        backgroundView = UIView(frame: self.view.frame)
        backgroundView?.backgroundColor = .gray
        backgroundView?.alpha = 0.7
        
        if let view = popupView, let bgView = backgroundView {
            self.view.addSubview(bgView)
            self.view.addSubview(view)
            self.navigationItem.title = view.source.name
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
        
    }
    func articlesButtonPressed() {
        performSegue(withIdentifier: Identifier.ViewController.ToArticles.rawValue, sender: self)
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








