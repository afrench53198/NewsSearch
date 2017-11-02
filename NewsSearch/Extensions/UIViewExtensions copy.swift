//
// UIViewExtensions.swift
//  DesignPatterns
//
//  Created by Adam B French on 9/28/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//
// The struct ViewLayout demonstrates the factory pattern. The factory pattern means the creation of an object may is encapsulated to the client.  ViewLayout creates a CGrect with a certain position in comparison to a guide view, but the client cannot see how the position is calculated when the creation of a layout is called.
import UIKit



enum ViewPosition {
    case bottomCenter
    case bottomLeft
    case bottomRight
    
    case topCenter
    case topLeft
    case topRight
    
    case center
    case left
    case right
}


extension UIView {
    
    public struct ViewLayout {
        
        var guide: CGRect
        var position: ViewPosition
        var size: CGSize
        var padding: CGFloat
        
        init(withFrame guideView: UIView, position: ViewPosition, size:CGSize, padding: CGFloat) {
            self.guide = guideView.frame
            self.position = position
            self.size = size
            self.padding = padding
        }
        init(withBounds guideView: UIView, position: ViewPosition, size:CGSize, padding: CGFloat) {
            self.guide = guideView.bounds
            self.position = position
            self.size = size
            self.padding = padding
        }
        
        var origin: CGPoint {
            switch position {
            case .bottomCenter:
                return CGPoint(x: guide.midX - size.width / 2 , y: guide.maxY - (size.height + padding))
            case .bottomLeft:
                return CGPoint(x: guide.minX + 32 , y: guide.maxY - (size.height + padding))
            case .bottomRight:
                return CGPoint(x: guide.maxX - (self.size.width + padding) , y: guide.maxY - (size.height + padding))
            case .topLeft:
                return CGPoint(x: guide.minX + padding , y: (guide.minY + padding))
            case .topRight:
                return CGPoint(x: guide.maxX - (self.size.width + padding) , y: (guide.minY + padding))
            case .topCenter:
                return CGPoint(x: guide.midX - (size.width / 2), y: guide.minY + padding)
            case .right:
                return CGPoint(x: guide.maxX - (size.width + 16), y: guide.midY  - (size.height / 2))
            case .left:
                return CGPoint(x: guide.minX + 16, y: guide.midY  - (size.height / 2))
            default:
                return CGPoint(x: guide.midX - (size.width / 2), y: guide.midY  - (size.height / 2))
            }
        }
        
        func makeLayout() -> CGRect {
            return CGRect(origin: origin, size: size)
        }
    }
    
}



