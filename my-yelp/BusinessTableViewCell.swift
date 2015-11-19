//
//  BusinessTableViewCell.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/19/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    var model: Business!{
        didSet{
            self.distanceLabel.text = self.model.distance
            self.categoriesLabel.text = self.model.categories
            self.addressLabel.text = self.model.address
            self.nameLabel.text = self.model.name

            let loadingImage = UIImage(contentsOfFile: "placeholder-image.png")
            
            var request = NSURLRequest(URL: self.model.imageURL!)
            self.businessImageView.setImageWithURLRequest(request, placeholderImage: loadingImage, success: {(request, response, image) -> Void in
                self.businessImageView.image = image
                }, failure: {(request, response, error) -> Void in
                
                })
            
            request = NSURLRequest(URL: self.model.ratingImageURL!)
            self.ratingImage.setImageWithURLRequest(request, placeholderImage: loadingImage, success: {(request, response, image) -> Void in
                self.ratingImage.image = image
                }, failure: {(request, response, error) -> Void in
                    
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.businessImageView.layer.cornerRadius = 3
        self.businessImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
