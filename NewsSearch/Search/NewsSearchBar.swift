//
//  NewsSearchBar.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class NewsSearchBar: UISearchBar {
    
    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
 
    
    init(frame: CGRect, font: UIFont, textColor: UIColor, tintColor: UIColor) {
   
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        barTintColor = tintColor
        self.tintColor = textColor
        
        self.showsCancelButton = true
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
    
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        configureShadow()
    }

    override func draw(_ rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let searchFieldIndex = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = subviews[0].subviews[searchFieldIndex] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: 0, y: 5, width: bounds.size.width - 80, height: bounds.size.height - 10)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        super.draw(rect)
    }
    
    private func indexOfSearchFieldInSubviews() -> Int! {
        
        var index = 0
        let searchBarView = subviews[0]
        
        repeat {
            let textField = searchBarView.subviews[index] as? UITextField
            if textField != nil {
                return index
            } else {
                index += 1
            }
        }   while index < searchBarView.subviews.count
        return index
    }

    
   private  func configureShadow() {
        let path = UIBezierPath(rect: self.bounds).cgPath
        let thisLayer = self.layer
        thisLayer.shadowColor = UIColor.black.cgColor
        thisLayer.shadowRadius = 20
        thisLayer.shadowPath = path
        thisLayer.shadowOpacity = 0
        thisLayer.shadowOffset = CGSize(width: 0, height: -5)
    }

}

