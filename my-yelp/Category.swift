//
//  Category.swift
//  my-yelp
//
//  Created by Anh-Tu Hoang on 11/22/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import Foundation

enum CategoryError: ErrorType {
    case WrongUrlFormat
    case NoNetwork
    case WrongJsonFormat
}

class Category: AnyObject{
    var alias: String
    var title: String
    static let categoryAPIUrl = "https://www.yelp.com/developers/documentation/v2/all_category_list/categories.json"
    
    init(dictionary: [String: AnyObject]){
        alias = dictionary["alias"] as! String
        title = dictionary["title"] as! String
    }
    
    class func catetories(array array: [[String:AnyObject]]) -> [Category] {
        var categories = [Category]()
        for dictionary in array {
            
            let category = Category(dictionary: dictionary)
            categories.append(category)
        }
        return categories
    }
    
    class func updateCategoriesFromServer(callback callback: (data: [Category]?, error: CategoryError?) -> Void) {
        guard let url = NSURL(string: Category.categoryAPIUrl) else {
            callback(data: nil, error: .WrongUrlFormat)
            return
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) {(data, response, error) -> Void in
            
            guard error == nil else {
                callback(data: nil, error: .NoNetwork)
                return
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [[String:AnyObject]]
    
                print (json)
                callback(data: Category.catetories(array: json), error: nil)
            }catch  {
                callback(data: nil, error: .WrongJsonFormat)
            }
        }
        
        task.resume()

    }
}