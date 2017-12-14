//
//  NewsViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 12/7/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class NewsTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    /// Instantiates and sets tab bar items to the view controllers within the tabbar controller 
    private func configureViewControllers() {
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Sources", image: #imageLiteral(resourceName: "Sources"), selectedImage: #imageLiteral(resourceName: "SourcesSelected"))
        let articlesVC = ArticlesViewController(nil)
        articlesVC.tabBarItem = UITabBarItem(title: "Articles", image: #imageLiteral(resourceName: "Articles"), selectedImage: #imageLiteral(resourceName: "ArticlesSelected "))
        
        var viewControllers = [homeVC,articlesVC]
        // Embeds view controllers in a navigation controller
        viewControllers = viewControllers.map{
        UINavigationController(rootViewController: $0)
        }
        self.viewControllers = viewControllers
       // Sets homeVC As initial selected view 
        self.selectedIndex = 0
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
