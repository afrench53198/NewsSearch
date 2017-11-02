//
//  NewsPopUpView.swift
//  NewsSearch
//
//  Created by Adam B French on 10/31/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class NewsPopUpView: UIView {
    
    var source: NewsSource
    var toWebsiteButton: UIButton!
    var closeButton: UIButton!
    var sourceDescriptionLabel: UILabel!

    
    init(with source: NewsSource, frame: CGRect) {
        self.source = source
        super.init(frame: frame)
        self.backgroundColor = .white
     

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.source = NewsSource(name: "String", description: "string", url: "string", category: "category")
        super.init(coder: aDecoder)
    }
    override func didMoveToWindow() {
        animateIn {
        configureShadow()
        configureViews()
        }
    }
    private func configureViews() {
        let toWebsiteFrame = UIView.ViewLayout(withBounds: self, position: .bottomCenter, size: CGSize(width:80, height: 40), padding: 32).makeLayout()
        let closeButtonFrame = UIView.ViewLayout(withBounds: self, position: .topLeft, size: CGSize(width:40, height: 40), padding: 8).makeLayout()
        let sourceDescriptionFrame = UIView.ViewLayout(withBounds: self, position: .center, size: CGSize(width:self.bounds.width-16, height: 200), padding: 8).makeLayout()
        let imageForButton: UIImage = #imageLiteral(resourceName: "close")
       
        toWebsiteButton = UIButton.makeTextButton(frame: toWebsiteFrame, type: .rounded, color: .darkGrey, title: "Website", target: nil, selector: nil)
        self.addSubview(toWebsiteButton)
      
        closeButton = UIButton.makeImageButton(frame: closeButtonFrame, image: imageForButton, pressedImage: nil, target: self, selector: #selector(closeButtonPressed(_:)))
        self.addSubview(closeButton)
       
        sourceDescriptionLabel = UILabel.createAhtauLabel(fontType: .system, fontSize: .p1, text: source.description, color: .black)
        sourceDescriptionLabel.numberOfLines = 10
        sourceDescriptionLabel.frame = sourceDescriptionFrame
        sourceDescriptionLabel.textAlignment = .center
        self.addSubview(sourceDescriptionLabel)
        
    }
    @objc func closeButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
 
    private func animateIn(completion: ()->()) {

        let thisLayer = self.layer
        let animation = CABasicAnimation(keyPath: "cornerRadius")
       
        animation.fromValue = 500
        animation.toValue = 5

        let animation2 = CABasicAnimation(keyPath: "shadowOpacity")
        animation2.fromValue = 0
        animation2.toValue = 1
     
        let group = CAAnimationGroup()
        group.animations = [animation,animation2]
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        group.autoreverses = false
        group.isRemovedOnCompletion = true
        thisLayer.add(group, forKey: "animations")
        
        completion()
    }
    
    private func animateOut() {
        
        DispatchQueue.main.async(group: nil, qos: .userInitiated, flags: .barrier) {
            let thisLayer = self.layer
            thisLayer.removeAllAnimations()
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = thisLayer.cornerRadius
            animation.toValue = 500
            animation.duration = 0.5
            thisLayer.cornerRadius = 500
            thisLayer.add(animation, forKey: "cornerRadius")
        }
    }
    
    private func configureShadow() {
        let thisLayer = self.layer
        thisLayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
        thisLayer.shadowColor = UIColor.black.cgColor
        thisLayer.shadowRadius = 30
         self.layer.shadowOpacity = 1
        thisLayer.cornerRadius = 5
    
    }


}
