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

    var isSelectedDeals: Bool!
    var selectedCategoriesState: [Int:Bool]!
    weak var delegate: FiltersViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCategoriesState = [Int:Bool]()
        
        
        // load yelp categories
        //loadYelpCategories()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
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
        for (row, isSelected) in selectedCategoriesState {
            if isSelected {
                selectedCategories.append(categories[row].alias)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        // get selected deal option
        filters["deals"] = isSelectedDeals
        
        // get selected distance option
        filters["distance"] = (self.data2["sort"]!["options"] as! [String])[selectedDistanceIndex]
        
        // get selected sort by option
        filters["sort"] = (self.data2["sort"]!["options"] as! [String])[selectedSortIndex]
        
        delegate?.filterViewController?(self, didUpdateFilters: filters)
    }
    
    let cellId = "FilterCell"
    let headerViewId = "TableViewHeaderView"

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
            "options": [
                Category(dictionary: ["alias": "3dprinting", "title": "3D Printing"]),
                Category(dictionary: ["alias": "abruzzese", "title": "Abruzzese"]),
                Category(dictionary: ["alias": "absinthebars", "title": "Absinthe Bars"])
            ],
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
        let type = headerData["type"] as! FilterType
        let headerCode = headers[section]
        
        if headerCode == "distance" {
            if isExpandDistance == false {
                return 1
            }
        } else if headerCode == "sort" {
            if isExpandSort == false {
                return 1
            }
        } else if headerCode == "category" {
            if isExpandCategories == false {
                return (options as! NSArray).count + 1
            }
        }
        
        return (options as! NSArray).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        let headerCode = headers[indexPath.section]
        let headerData: [String:Any] = data2[headerCode]!
        let type = headerData["type"] as! FilterType
        
        switch type {
        case .MultiValue:
            
                var text: String
                if headerCode == "category" {
                    let options = headerData["options"] as! [Category]
                    
                    if indexPath.row == options.count && isExpandCategories == false {
                        // show see all cell
                        let seeAllCell = tableView.dequeueReusableCellWithIdentifier("SeeAllCell", forIndexPath: indexPath) as UITableViewCell
                        return seeAllCell
                    }
                    
                    text = options[indexPath.row].title
                } else {
                    let options = headerData["options"] as! [String]
                    text = options[indexPath.row]
                }
                let cell = tableView.dequeueReusableCellWithIdentifier("MultiValueCell", forIndexPath: indexPath) as! MultiValueTableViewCell
                
                cell.switchLabel.text = text
                cell.delegate = self
                
                if selectedCategoriesState[indexPath.row] != nil {
                    cell.onSwitch.on = selectedCategoriesState[indexPath.row]!
                } else {
                    cell.onSwitch.on = false
                }
                
                cell.onSwitch.on = selectedCategoriesState[indexPath.row] ?? false
                
                return cell
        case .SingleValue:
                let options = headerData["options"] as! [String]
                let cell = tableView.dequeueReusableCellWithIdentifier("SingleValueCell", forIndexPath: indexPath) as! SingleValueTableViewCell
                var index = indexPath.row
                cell.accessoryType = UITableViewCellAccessoryType.None
                
                if headerCode == "distance" {

                    if isExpandDistance == false {
                        index = selectedDistanceIndex
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        //cell.data = options[selectedDistanceIndex]
                    } else if index == selectedDistanceIndex{
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                } else {
                    if isExpandSort == false {
                        index = selectedSortIndex
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        //cell.data = options[selectedDistanceIndex]
                    } else if index == selectedSortIndex{
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                }

                cell.data = options[index]
                return cell
        }
    }
    
    var isExpandCategories = false
    var isExpandDistance = false
    var selectedDistanceIndex = 0
    var isExpandSort = false
    var selectedSortIndex = 0
    
    func tableView(_ tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let headerCode = headers[indexPath.section]
        let headerData = data2[headerCode]!
            
        if headerCode == "category" {
            let options = headerData["options"] as! [Category]
            if indexPath.row == options.count {
                if isExpandCategories == false {
                    loadYelpCategories()
                    isExpandCategories = true
                    tableView.reloadData()
                        
                }
            }
        } else if headerCode == "distance"{
            if isExpandDistance == false {
                // expand distance
                isExpandDistance = true
            } else {
                selectedDistanceIndex = indexPath.row
                isExpandDistance = false
            }
            tableView.reloadData()
        } else if headerCode == "sort" {
            if isExpandSort == false {
                isExpandSort = true
            } else {
                selectedSortIndex = indexPath.row
                isExpandSort = false
            }
            tableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    func switchCell(switchCell: MultiValueTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        let headerCode = headers[indexPath.section]
    
        if headerCode == "deals" {
            isSelectedDeals = value
        } else {
            selectedCategoriesState[indexPath.row] = value
        }
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
