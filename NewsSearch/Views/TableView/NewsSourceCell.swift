//
//  NewsSourceCell.swift
//  NewsSearch
//
//  Created by Adam B French on 10/25/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

class NewsSourceCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var SourceName: UILabel!
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var SourceDescription: UILabel!
    
    func configure(with data:NewsSource){
        SourceName.text = data.name
        Category.text = data.category
        SourceDescription.text = data.description
        SourceName.layer.cornerRadius = 5
    }
    

    
}
