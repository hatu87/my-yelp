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

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CategoryTableViewCellDelegate {

    var categories: [[String:String]]!
    var switchStates: [Int:Bool]!
    weak var delegate: FiltersViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        switchStates = [Int:Bool]()
        
        // Do any additional setup after loading the view.
        self.categories = yelpCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(CategoryTableViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerViewId)
    }

    func yelpCategories() -> [[String:String]]{
        return [["name": "Afghan", "code":"afghani"],
                ["name": "African", "code":"african"],
                ["name": "American, New", "code": "newamerican"]]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String:AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
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
    let data = [("", ["Offering a Deal"]),
                        ("Distance", ["0.3 miles", "1 mile", "5 miles", "20 miles"]),
                        ("Sort By", ["Best Match", "Distance", "Highest Rated"]),
                        ("Category", ["Afghan", "African"])]
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(self.headerViewId)

        header!.textLabel!.text = data[section].0
        return header
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.data[section].1.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(categoryCellId, forIndexPath: indexPath) as! CategoryTableViewCell
        
        cell.switchLabel.text = self.data[indexPath.section].1[indexPath.row]
        cell.delegate = self
        
        if switchStates[indexPath.row] != nil {
            cell.onSwitch.on = switchStates[indexPath.row]!
        } else {
            cell.onSwitch.on = false
        }
        
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func switchCell(switchCell: CategoryTableViewCell, didChangeValue value: Bool) {
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
