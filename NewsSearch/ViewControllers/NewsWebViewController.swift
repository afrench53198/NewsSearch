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

    var webView: NewsWebView!
    var urlString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
    }

    private func configureWebView() {
        let configuration = WKWebViewConfiguration()
        webView = NewsWebView(frame: self.view.frame, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        guard let thisUrl = URL(string: urlString!) else {print("Faulty Url in NewsWebViewController");return }
        let urlRequest = URLRequest(url: thisUrl)
        webView.load(urlRequest)
        self.view.addSubview(webView)
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
