//
//  ArticlesViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 11/6/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {
    
    var tableView: NewsTableView!
    var viewModel: ArticlesTableViewModel!
    var source: NewsSource?
    let articlesNetworker = NetworkManager()
    var searchBar: NewsSearchBar?
    var selectedArticle: NewsArticle?
    var popupView: NewsPopupView?
    
    init( _ source: NewsSource?) {
        super.init(nibName: nil, bundle: nil)
        self.title = "\(source?.name ?? "") articles"
        self.source = source
        configureNavBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    override func viewDidLayoutSubviews() {
        setupViews()
    }
    /// This Function sets up all the inital frames for views and injects dependencies
    private func configure() {
        configureNavBar()
        configureTableView()
        guard let source = self.source else {viewModel = ArticlesTableViewModel(with: articlesNetworker, tableView: tableView); return}
        viewModel = ArticlesTableViewModel(with: articlesNetworker, tableView: tableView, source: source)
    }
    /// Sets frame again if needed for device rotation
    private func setupViews() {
        let tableViewSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 40)
        let tableViewFrame = UIView.ViewLayout(withBounds: self.view, position: .bottomCenter, size: tableViewSize, padding: (0,0)).makeInnerLayout()
        tableView.frame = tableViewFrame
    }
    /// Sets Table View frame and data source/delegate
    private func configureTableView() {
        let tableViewSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 40)
        let tableViewFrame = UIView.ViewLayout(withBounds: self.view, position: .bottomCenter, size: tableViewSize, padding: (0,0)).makeInnerLayout()
        tableView = NewsTableView(frame: tableViewFrame, style: .plain, type: Identifier.TableViewCell.ArticleCell)
        tableView.dataSource = viewModel
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    ///Styles the Navigation Bar
    private func configureNavBar () {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        guard let source = self.source else {self.navigationItem.title = "Articles"; return}
        self.navigationItem.title = "\(source.name) Articles"
        let item = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismiss(sender:)))
        self.navigationItem.setLeftBarButton(item, animated: false)
    }
    
    
    @objc private func dismiss(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.returnData(at: indexPath.row)
        let controller = ArticleDetailViewController(item: data)
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
}
