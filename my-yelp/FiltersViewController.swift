//
//  FiltersViewController.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/19/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filterViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

enum FilterType {
    case SingleValue
    case MultiValue
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MultiValueTableViewCellDelegate {

    var switchStates: [Int:Bool]!
    weak var delegate: FiltersViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        switchStates = [Int:Bool]()
        
        
        // load yelp categories
        loadYelpCategories()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(MultiValueTableViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerViewId)
    }
    
    func loadYelpCategories() {
        Category.updateCategoriesFromServer(callback: {(data, error) -> Void in
            guard error == nil else {
                switch error! {
                case CategoryError.NoNetwork:
                    print("No network")
                case CategoryError.WrongJsonFormat:
                    print("Wrong json format")
                case CategoryError.WrongUrlFormat:
                    print("wrong url format")
                }
                
                return
            }
            
            if let categories = data as [Category]! {
                self.data2["category"]!["options"] = categories
                
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        // get selected categories
        let categories = self.data2["category"]!["options"] as! [Category]
        
        var filters = [String:AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row].alias)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filterViewController?(self, didUpdateFilters: filters)
    }
    
    let cellId = "FilterCell"
    let headerViewId = "TableViewHeaderView"
    let categoryCellId = "MyCell"
    let headers = ["deals", "distance", "sort", "category"]
    var data2: [String:[String:Any]] = [
        "deals": [
            "title": "",
            "options": ["Offering a Deal"],
            "type": FilterType.MultiValue
        ],
        "distance": [
            "title": "Distance",
            "options": [ "0.3 miles", "1 mile", "5 miles", "20 miles"],
            "type": FilterType.SingleValue
        ],
        "sort": [
            "title": "Sort By",
            "options": ["Best Match", "Distance", "Highest Rated"],
            "type": FilterType.SingleValue
        ],
        "category": [
            "title": "Category",
            "options": [],
            "type": FilterType.MultiValue
        ]
    ]
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(self.headerViewId)
        let headerData: [String:Any] = data2[headers[section]]!
        let text = headerData["title"] as! String
        
        header!.textLabel!.text = text
        return header
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let headerData: [String:Any] = data2[headers[section]]!
        let options = headerData["options"]
        
        return (options as! NSArray).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(categoryCellId, forIndexPath: indexPath) as! MultiValueTableViewCell

        let headerCode = headers[indexPath.section]
        let headerData: [String:Any] = data2[headerCode]!

        if headerCode == "category" {
            let options = headerData["options"] as! [Category]
            let text = options[indexPath.row].title
            cell.switchLabel.text = text
            
            cell.delegate = self
            
            if switchStates[indexPath.row] != nil {
                cell.onSwitch.on = switchStates[indexPath.row]!
            } else {
                cell.onSwitch.on = false
            }
            
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            
            return cell
        } else if headerCode == "deals" {
            let options = headerData["options"] as! [String]
            cell.delegate = self
            cell.switchLabel.text = options[indexPath.row]
            
            return cell
        } else {
            let options = headerData["options"] as! [String]
            cell.delegate = self
            cell.switchLabel.text = options[indexPath.row]
            
            return cell
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    func switchCell(switchCell: MultiValueTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        
        switchStates[indexPath.row] = value
        print("filter views got the switch cell")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
