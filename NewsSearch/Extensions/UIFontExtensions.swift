//
//  UIFontExtensions.swift
//  DesignPatterns
//
//  Created by Adam B French on 10/15/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func makeFont(fontType: FontType, fontSize: FontSize) -> UIFont {
        switch fontType {
        case .system:   return  UIFont.systemFont(ofSize: fontSize.rawValue, weight: UIFont.Weight(rawValue: 0.1))
        case .systemSemiBold:  return UIFont.systemFont(ofSize: fontSize.rawValue, weight: UIFont.Weight(rawValue: 0.4))
        case .systemBold: return UIFont.systemFont(ofSize: fontSize.rawValue, weight: UIFont.Weight(rawValue: 0.6))
        default:  guard let aFont = UIFont(name: fontType.rawValue, size: fontSize.rawValue) else {print("invalid Font"); return UIFont()}
            return aFont
    }
    
    
}
}
