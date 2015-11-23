//
//  SingleValueTableViewCell.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/22/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

class SingleValueTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    var data: String! {
        didSet {
            label.text = data
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
