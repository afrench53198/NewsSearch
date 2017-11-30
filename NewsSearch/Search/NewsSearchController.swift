//
//  NewsSearchController.swift
//  NewsSearch
//
//  Created by Adam B French on 10/24/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit
@objc protocol CustomSearchControllerDelegate {
    func didStartSearching()
    
    func didTapOnSearchButton()
    
    func didTapOnCancelButton()
    
    func didChangeSearchText(searchText: String)
    
    @objc optional func scopeBarIndexDidChange(to index: Int)
}

class NewsSearchController: UISearchController, UISearchBarDelegate {
    // TODO: - Set Shadow path on animation so it moves smoothly with view
    var customSearchBar: NewsSearchBar!
    var customDelegate: CustomSearchControllerDelegate!
    var shadowOn: Bool = false 
    
    init(searchResultsController: UIViewController?,frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor ) {
        super.init(searchResultsController: searchResultsController)
        customSearchBar = NewsSearchBar(frame: frame, font: font, textColor: textColor, tintColor: bgColor)
        customSearchBar.delegate = self
        dimsBackgroundDuringPresentation = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func toggleShadowAndScopeBar() {
        
        let thisLayer = self.customSearchBar.layer
        
        if shadowOn {
            self.customSearchBar.showsScopeBar = false
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    // Animations to shrink view and animate out shadow
                    thisLayer.shadowOpacity = 0
                    thisLayer.shadowOffset.height -= 48
                    self.customSearchBar.frame.height -= 48
                })
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    // Animations to grow view and animate in shadow
                    thisLayer.shadowOpacity = 0.7
                    self.customSearchBar.frame.height += 48
                    thisLayer.shadowOffset.height += 48
                    self.customSearchBar.showsScopeBar = true
                })
            }
        }
        shadowOn = !shadowOn
    }
  
// MARK: - Search delegate
func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    customDelegate.didStartSearching()
}
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    customSearchBar.resignFirstResponder()
    customDelegate.didTapOnSearchButton()
}
func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    customSearchBar.resignFirstResponder()
    customDelegate.didTapOnCancelButton()
}
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    customDelegate.didChangeSearchText(searchText: searchText)
}
func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    customDelegate.scopeBarIndexDidChange!(to: selectedScope)
}


}


