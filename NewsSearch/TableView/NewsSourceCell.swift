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
    
    @IBOutlet weak var Url: UILabel!
    @IBOutlet weak var SourceDescription: UILabel!
    
    func configure(with data:NewsSource){
        SourceName.text = data.name
        Url.text = data.url
        SourceDescription.text = data.description
    }
    

    
}
