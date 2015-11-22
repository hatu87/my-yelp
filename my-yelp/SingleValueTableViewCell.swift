//
//  SingleValueTableViewCell.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/22/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

class SingleValueTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    var data: [String]! {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard data != nil else {
            return 0
        }
        return data.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard data != nil else {
            return ""
        }
        
        return data[row]
    }

}
