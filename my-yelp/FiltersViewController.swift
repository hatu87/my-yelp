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

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! SwitchTableViewCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        if switchStates[indexPath.row] != nil {
            cell.onSwitch.on = switchStates[indexPath.row]!
        } else {
            cell.onSwitch.on = false
        }
        
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool) {
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
