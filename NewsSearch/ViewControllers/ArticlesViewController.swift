//
//  ArticlesViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 11/6/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {
 // TODO: - Make Table view and view model so the controller fills with articles from selected source

    
    var tableView: ArticlesTableView!
    var viewModel: ArticlesViewModel!
    var source: NewsSource!

 
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
    }
    override func viewDidLayoutSubviews() {
        setupViews()
    }
    @objc func backItemPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    // This Function sets up all the frames for views and injects dependencies
    private func configure() {
        configureNavBar()
        configureTableView()
        viewModel = ArticlesViewModel(with: NetworkManager(), tableView: tableView, source: source)
    
    }
   // Sets frame in DidLayoutSubviews so when the device rotates the views orient themselves correctly
    private func setupViews() {
        let tableViewSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 40)
        let tableViewFrame = UIView.ViewLayout(withBounds: self.view, position: .bottomCenter, size: tableViewSize, padding: 0).makeLayout()
        tableView.frame = tableViewFrame
        
    }
   /// Sets Table View frame and data source/delegate
    private func configureTableView() {
        let tableViewSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 40)
        let tableViewFrame = UIView.ViewLayout(withBounds: self.view, position: .bottomCenter, size: tableViewSize, padding: 0).makeLayout()
        tableView = ArticlesTableView(frame: tableViewFrame, style: .plain)
        tableView.dataSource = viewModel
        self.view.addSubview(tableView)
    }
    //Styles the Navigation Bar 
    private func configureNavBar () {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "\(source.name) Articles"

    }
   
    
    
    
    
}
