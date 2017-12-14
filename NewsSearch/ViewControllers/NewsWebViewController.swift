//
//  NewsWebViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 11/16/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var newsSource: NewsSource!

    init(_ source: NewsSource) {
        super.init(nibName: nil, bundle: nil)
        newsSource = source
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureNavBar()
    }

    private func configureWebView() {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        guard let thisUrl = URL(string: newsSource.url) else {print("Faulty Url in NewsWebViewController");return }
        let urlRequest = URLRequest(url: thisUrl)
        webView.load(urlRequest)
        self.view.addSubview(webView)
    }
    
    private func configureNavBar () {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "\(newsSource.name) Website"
        let item = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismiss(animated:completion:)))
        self.navigationItem.setLeftBarButton(item, animated: false)
    }
  

}
