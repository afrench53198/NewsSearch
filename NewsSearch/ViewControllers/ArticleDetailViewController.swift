//
//  ArticleDetailViewController.swift
//  NewsSearch
//
//  Created by Adam B French on 12/14/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    var item: NewsItem
    var delegate: PopupViewDelegate?
    private var articleImageView: UIImageView!
    private var articleTitleLabel: UILabel!
    private var articleDescriptionLabel: UILabel!
    private var dateLabel: UILabel!
    private var authorLabel: UILabel!
    private var sourceLabel: UILabel!
    private var imageViewOverlay: UIView!
    private var toWebsiteButton: UIButton!
    init(item: NewsItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.item = NewsArticle()
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureNavBar()
        configureViews()
    }
    
    private func configureViews() {
        
        guard let article = item as? NewsArticle else {return}
        let titleLabelFrame = UIView.ViewLayout(withBounds: view, position: .topCenter, size:  CGSize(width: self.view.bounds.width - 16, height: 30), padding: (80, 0)).makeInnerLayout()
        articleTitleLabel = UILabel.makeLabel(fontType: .font1Heavy, fontSize: .p1, text: "\(article.title ?? "Article")", color: .black)
        articleTitleLabel.frame = titleLabelFrame
        articleTitleLabel.numberOfLines = 4
        articleTitleLabel.sizeToFit()
        articleTitleLabel.textAlignment = .center
        self.view.addSubview(articleTitleLabel)
        
        let imageViewFrame = UIView.ViewLayout(withBounds: view, position: .topCenter, size: CGSize(width: self.view.bounds.width - 16, height: self.view.bounds.height/2), padding: (150, 0)).makeInnerLayout()
        articleImageView = UIImageView(frame: imageViewFrame)
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.layer.cornerRadius = 5
        articleImageView.clipsToBounds = true
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            articleImageView.sd_setImage(with: url)
        } else {
         articleImageView.image = #imageLiteral(resourceName: "close")
        }
        self.view.addSubview(articleImageView)
      
        let imageViewOverlayFrame = UIView.ViewLayout(withFrame: articleImageView, position: .bottomCenter, size: CGSize(width: imageViewFrame.width, height: 40), padding: (0, 0)).makeInnerLayout()
        imageViewOverlay = UIView(frame: imageViewOverlayFrame)
        imageViewOverlay.backgroundColor = .darkGray
        imageViewOverlay.alpha = 0.7
        imageViewOverlay.layer.cornerRadius = 5
        self.view.addSubview(imageViewOverlay)
        
        let dateLabelFrame = UIView.ViewLayout(withFrame: imageViewOverlay, position: .left, size: CGSize(width: imageViewOverlayFrame.width / 4,height: imageViewOverlayFrame.height), padding: (0, 8)).makeInnerLayout()
        if let string = article.publishedAt, let date = string.dateFromTimestamp?.relativelyFormatted(short: false) {
            dateLabel = UILabel.makeLabel(fontType: .font1Light, fontSize: .p3, text: "\(date)", color: .white)
            dateLabel.frame = dateLabelFrame
            self.view.addSubview(dateLabel)
        }
        
        let authorLabelFrame = UIView.ViewLayout(withFrame: imageViewOverlay, position: .right, size: CGSize(width: imageViewOverlayFrame.width / 1.75,height: imageViewOverlayFrame.height), padding: (0, 8)).makeInnerLayout()
        if let string = article.author {
            authorLabel = UILabel.makeLabel(fontType: .font1Light, fontSize: .p3, text: "\(string)", color: .white)
            authorLabel.frame = authorLabelFrame
            authorLabel.textAlignment = .right
            self.view.addSubview(authorLabel)
        }
        
        let descriptionLabelFrame = CGRect(x: view.bounds.x + 8, y: imageViewFrame.maxY + 8 , width: view.bounds.width - 16, height: self.view.bounds.height / 3)
        if let string = article.description {
            articleDescriptionLabel = UILabel.makeLabel(fontType: .font1Regular, fontSize: .p2, text: "\(string)", color: .black)
            articleDescriptionLabel.frame = descriptionLabelFrame
            articleDescriptionLabel.numberOfLines = 20
            articleDescriptionLabel.minimumScaleFactor = 0.7
            articleDescriptionLabel.sizeToFit()
            articleDescriptionLabel.textAlignment = .center
            self.view.addSubview(articleDescriptionLabel)
        }
        
        let toWebsiteButtonFrame = UIView.ViewLayout(withBounds: view, position: .bottomCenter, size: CGSize(width: view.bounds.width - 16, height: 40), padding: (8, 0)).makeInnerLayout()
        toWebsiteButton = UIButton.makeTextButton(frame: toWebsiteButtonFrame, type: .rounded, color: .black, title: "Read on Website", target:self, selector: #selector(toWebsite(sender:)))
        self.view.addSubview(toWebsiteButton)
        
        let sourceLabelFrame = UIView.ViewLayout(withFrame: toWebsiteButton, position: .topCenter, size: CGSize(width: articleImageView.bounds.width, height: 30), padding: (0, 0)).makeOuterLayout()
        sourceLabel = UILabel.makeLabel(fontType: .systemSemiBold, fontSize: .p1, text: "\(article.source.name)", color: .black)
        sourceLabel.frame = sourceLabelFrame
        sourceLabel.textAlignment = .center

        self.view.addSubview(sourceLabel)
       
    }
    
    private func configureNavBar () {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let barItem = UIBarButtonItem(title: "Back To Articles", style: .done, target: self, action: #selector(close(sender:)))
        self.navigationItem.setLeftBarButton(barItem, animated: false)
    }
    
    @objc private func toWebsite(sender: UIButton) {
        let controller = NewsWebViewController(item)
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }

    @objc private func close(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

    


