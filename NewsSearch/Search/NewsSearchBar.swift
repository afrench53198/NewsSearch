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
    var shadowOn: Bool
    
    init(frame: CGRect, font: UIFont, textColor: UIColor, tintColor: UIColor) {
        shadowOn = false
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        barTintColor = tintColor
        self.tintColor = textColor
        
        self.showsCancelButton = true
        
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
        
        self.showsScopeBar = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        shadowOn = false
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: 0, y: 5, width: frame.size.width - 80, height: frame.size.height - 10)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
            
            let path = UIBezierPath(rect: self.bounds).cgPath
            let thisLayer = self.layer
            thisLayer.shadowColor = UIColor.black.cgColor
            thisLayer.shadowRadius = 10
            thisLayer.shadowPath = path
            thisLayer.shadowOpacity = 0
            thisLayer.shadowOffset = CGSize(width: 0, height: 3)
            
        }
        super.draw(rect)
    }
    
    func toggleShadow() {
        
        let thisLayer = self.layer
        if shadowOn {
            thisLayer.removeAllAnimations()
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = 0.7
            animation.toValue = 0
            animation.duration = 0.5
            thisLayer.add(animation, forKey: "shadowOpacity")
             thisLayer.shadowOpacity = 0
        } else {
            thisLayer.removeAllAnimations()
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = 0
            animation.toValue = 0.7
            animation.duration = 0.5
            thisLayer.add(animation, forKey: "shadowOpacity")
            thisLayer.shadowOpacity = 0.7
        }
        shadowOn = !shadowOn
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
    
    
  
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
