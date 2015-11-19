//
//  SwitchCell.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/19/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool)
}

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    weak var delegate: SwitchCellDelegate?
    
    
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
