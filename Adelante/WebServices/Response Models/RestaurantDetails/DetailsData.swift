//
//  DetailsData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 18, 2021

import Foundation
import SwiftyJSON


class DetailsData : NSObject, NSCoding{

    var category : Category!
    var menuItem : [MenuItem]!
    var restaurantDetails : RestaurantDetailsData!
    var review : Review!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let categoryJson = json["category"]
        if !categoryJson.isEmpty{
            category = Category(fromJson: categoryJson)
        }
        menuItem = [MenuItem]()
        let menuItemArray = json["menu_item"].arrayValue
        for menuItemJson in menuItemArray{
            let value = MenuItem(fromJson: menuItemJson)
            menuItem.append(value)
        }
        let restaurantJson = json["restaurant"]
        if !restaurantJson.isEmpty{
            restaurantDetails = RestaurantDetailsData(fromJson: restaurantJson)
        }
        let reviewJson = json["review"]
        if !reviewJson.isEmpty{
            review = Review(fromJson: reviewJson)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if category != nil{
        	dictionary["category"] = category.toDictionary()
        }
        if menuItem != nil{
        var dictionaryElements = [[String:Any]]()
        for menuItemElement in menuItem {
        	dictionaryElements.append(menuItemElement.toDictionary())
        }
        dictionary["menuItem"] = dictionaryElements
        }
        if restaurantDetails != nil{
        	dictionary["restaurant"] = restaurantDetails.toDictionary()
        }
        if review != nil{
        	dictionary["review"] = review.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		category = aDecoder.decodeObject(forKey: "category") as? Category
		menuItem = aDecoder.decodeObject(forKey: "menu_item") as? [MenuItem]
		restaurantDetails = aDecoder.decodeObject(forKey: "restaurant") as? RestaurantDetailsData
		review = aDecoder.decodeObject(forKey: "review") as? Review
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if category != nil{
			aCoder.encode(category, forKey: "category")
		}
		if menuItem != nil{
			aCoder.encode(menuItem, forKey: "menu_item")
		}
		if restaurantDetails != nil{
            aCoder.encode(RestaurantDetailsData.self, forKey: "restaurant")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}

	}

}
