//
//  ViewController.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/17/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchResultsUpdating {


    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    var searchCtrl: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        initSearchBar()
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
    }

    var searchBar: UISearchBar!
    
    func initSearchBar(){
        // init search bar
        searchCtrl = UISearchController(searchResultsController: nil)
        searchCtrl.searchBar.sizeToFit()
        navigationItem.titleView = searchCtrl.searchBar
        searchCtrl.hidesNavigationBarDuringPresentation = false
        searchCtrl.dimsBackgroundDuringPresentation = false

        searchCtrl.searchResultsUpdater = self
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        let searchText = searchController.searchBar.text
        
        
        Business.searchWithTerm(searchText!, sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

    func searchOffline(){
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard self.businesses != nil else{
            return 0
        }
        
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessTableViewCell
        
        let business = self.businesses[indexPath.row]
        
        cell.model = business
        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filterViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        var categories = filters["categories"] as? [String]
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: categories, deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()            
        }

    }
}

