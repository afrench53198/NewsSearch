//
//  UILabelExtensions.swift
//  DesignPatterns
//
//  Created by Adam B French on 9/21/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit


// Example of "decorator" design pattern, made easy with extensions. Decorator Design Pattern 



public enum FontSize: CGFloat {
    
    case h1 = 56
    case h2 = 48
    case h3 = 40
    case h4 = 32
    case h5 = 24
    
    case p1 = 20
    case p2 = 16
    case p3 = 12
    
    case ss = 10
}

public enum FontType: String{
    case font1Regular = "Helvetica"
    case font1Heavy = "Helvetica-Bold"
    case font1Light = "Helvetica-Light"
    
    case system = "System"
    case systemSemiBold = "System-Semibold"
    case systemBold = "System-Bold"
}

public enum ColorScheme {
 
    case white
    case lightGrey
    case darkGrey
    case black
}

extension UILabel {
    
     static func makeLabel(fontType: FontType, fontSize: FontSize, text: String, color: ColorScheme) -> UILabel {
        
        let label = UILabel()
       
        label.font = UIFont.makeFont(fontType: fontType, fontSize: fontSize)
        
        switch color {
        case .lightGrey: label.textColor = UIColor.gray
        case .darkGrey: label.textColor = UIColor.darkGray
        case .black: label.textColor = .black
        case .white: label.textColor = .white
        }
        
        label.text = text
        label.backgroundColor = .clear
        label.clipsToBounds = true
        
        return label
    }
}
