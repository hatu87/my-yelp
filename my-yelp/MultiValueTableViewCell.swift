//
//  SwitchCell.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/19/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

@objc protocol MultiValueTableViewCellDelegate {
    optional func switchCell(switchCell: MultiValueTableViewCell, didChangeValue value: Bool)
}

class MultiValueTableViewCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    weak var delegate: MultiValueTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged(){
        print("Value changed")
        self.delegate?.switchCell?(self, didChangeValue: self.onSwitch.on)

    }

}
