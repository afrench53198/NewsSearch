//
//  UIButtonExtensions.swift
//  DesignPatterns
//
//  Created by Adam B French on 9/22/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit




//  The static functions demonstrate the Factory Method Pattern. The Factory Pattern is to create object without exposing the creation logic to the client and refer to newly created object using a common interface. The Factory Method Pattern does the same thing, but with static functions. These funcs are responsible for creating buttons with a certain title and triggered function, as well as buttons with an image for it's normal and an optional image for it's highlighted state. They're also reminiscent of the builder pattern, where a more complex creation process is simplified with a client API.
extension UIButton {
  
    
    enum ButtonType {
        case rounded
        case circle
        case regular
    }
    /// Returns a button with a title, a color scheme, and optional action. When using this function, you might find it useful to specify a frame before, although it's not required.
    static func makeTextButton(frame: CGRect?,type: ButtonType,color:ColorScheme, title: String, target: Any?, selector: Selector?) -> UIButton {
       
        var button = UIButton(type: .custom)
      
        switch color {
        case .lightGrey:
            button.backgroundColor = UIColor.lightGray
        case .darkGrey:
            button.backgroundColor = UIColor.darkGray
        case .black:
            button.backgroundColor = UIColor.black
        }
        
        switch type {
        case .circle:
            button.layer.cornerRadius = button.frame.width / 2
        case .rounded:
            button.layer.cornerRadius = 10
        default: break
        }
        guard let theFrame = frame else {return button}
        button.frame = theFrame
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)

        guard let target = target,let selector = selector else {return button}
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        return button
    }
 
    static func makeImageButton(frame: CGRect?, image: UIImage?, pressedImage: UIImage?, target: Any?, selector: Selector?) -> UIButton {
        
        var button = UIButton(type: .custom)
        
        guard  let normalImage = image else {return button}
        button.setBackgroundImage(normalImage, for: .normal)
       
        guard let theFrame = frame else {return button}
        button.frame = theFrame
   
        guard let target = target,let selector = selector else {return button}
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        guard let pressedImage = pressedImage else {return button}
        button.setBackgroundImage(pressedImage, for: .highlighted)
       
        return button

    }
        
   



}

