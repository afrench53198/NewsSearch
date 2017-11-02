//
//  CGRectExtensions.swift
//  Ahtau
//
//  Created by Mark Hamilton on 4/22/16.
//  Copyright © 2016 dryverless. All rights reserved.
//

import UIKit

public extension CGRect {
    
//    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
//    
//        self.init(x: x, y: y, width: width, height: height)
//    
//    }
    
    public var x: CGFloat {
        
        get {
        
            return self.origin.x
        
        } set {
        
            self.origin.x = newValue
    
        }
    
    }
    
    public var y: CGFloat {
        
        get {
        
            return self.origin.y
    
        } set {
            
            self.origin.y = newValue
        
        }
    
    }
    
    public var width: CGFloat {
        
        get {
        
            return self.size.width
        
        } set {
        
            self.size.width = newValue
    
        }
    
    }
    
    public var height: CGFloat {
        
        get {
        
            return self.size.height
        
        } set {
        
            self.size.height = newValue
        
        }
    }
    
}
