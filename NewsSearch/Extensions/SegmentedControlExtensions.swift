//
//  SegmentedControlExtensions.swift
//  NewsSearch
//
//  Created by Adam B French on 10/23/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    static func makeControl(color:UIColor, items: [Any], frame:CGRect?,action: Selector?) -> UISegmentedControl {
        let control = UISegmentedControl(items: items)
        if let theFrame = frame {
            control.frame = theFrame
        }
        control.tintColor = color
        control.selectedSegmentIndex = 0
        if action != nil {
              control.addTarget(self, action: action!, for: .valueChanged)
        }
      
        return control
    }

}
