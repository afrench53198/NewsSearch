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
    var searchBar = NewsSearchBar(frame: CGRect(), font: UIFont.systemFont(ofSize: 16), textColor: .white, tintColor: .black)
    var tableView: NewsTableView!


    //TODO: - Make table View controller with view model and networker to display sources
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configure()
        
    }
    
//    override func viewDidLayoutSubviews() {
//       setupViews()
//    }
//
// func setupViews() {
//        let controlSize = CGSize(width: self.view.frame.width, height: 32)
//        let sourceFrame = UIView.ViewLayout(guideView: self.view, position: .bottomCenter, size: controlSize, padding: 80).makeLayout()
//        sourceSegmentedControl?.frame = sourceFrame
//    }
    
    func configure() {
        viewModel = NewsSourceViewModel(with: networker)
        configureSegmentedControl()
        configureSearchController()
        configureTableView()
    }
   
    func configureSegmentedControl() {
        let items: [String] = ["all", SourceCategory.sport.rawValue,SourceCategory.business.rawValue,SourceCategory.music.rawValue,SourceCategory.politics.rawValue]
        let controlSize = CGSize(width: self.view.frame.width, height: 32)
        let sourceFrame = UIView.ViewLayout(guideView: self.view, position: .bottomCenter, size: controlSize, padding:0).makeLayout()
        let control = UISegmentedControl.makeControl(color: .black, items: items, frame: sourceFrame, action: nil)
        control.addTarget(self, action: #selector(sourceControlValueChanged(_:)), for: .valueChanged)
        sourceSegmentedControl = control
        self.view.addSubview(sourceSegmentedControl)
    }
 
    func configureTableView(){
    let tableViewFrame = CGRect(x: self.view.bounds.origin.x, y: self.view.frame.minY + 68, width: self.view.bounds.width, height: self.view.frame.height - 150)
        tableView = NewsTableView(frame: tableViewFrame, style: .plain)
        tableView.layoutMargins = UIEdgeInsetsMake(0, 8, 0, 8)
        loadArticles()
        self.view.addSubview(self.tableView)
        
    }
   
    
    func configureSearchController() {
        
        let barFrame = CGRect(x:self.view.frame.origin.x, y: self.view.frame.origin.y + 20  , width: self.view.frame.width, height: 48)
        
        newsSearchController = NewsSearchController(searchResultsController: nil, frame: barFrame, font: UIFont.systemFont(ofSize: 16), textColor: .white, bgColor: .black)
        
         newsSearchController.customSearchBar.placeholder = "Search Your Sources!"
        self.view.addSubview(newsSearchController.customSearchBar)
        
    }
   
    @objc func sourceControlValueChanged(_ sender: UISegmentedControl!) {
        print(sender.selectedSegmentIndex)
    }
    
    private func loadArticles() {
        viewModel.provideData { (result) in
            switch result {
            case .success(let sourceArray):
                self.tableView.sources = sourceArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
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

}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.removeFromSuperview()
        
        
    }
    
    
    
}


