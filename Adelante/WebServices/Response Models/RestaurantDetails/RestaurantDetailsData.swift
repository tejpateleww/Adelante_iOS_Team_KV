//
//  RestaurantDetailsData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 8, 2021

import Foundation
import SwiftyJSON


class RestaurantDetailsData : NSObject, NSCoding{

    var menuItem : [MenuItem]!
    var restaurant : Restaurant!
    var review : Review!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        menuItem = [MenuItem]()
        let menuItemArray = json["menu_item"].arrayValue
        for menuItemJson in menuItemArray{
            let value = MenuItem(fromJson: menuItemJson)
            menuItem.append(value)
        }
        let restaurantJson = json["restaurant"]
        if !restaurantJson.isEmpty{
            restaurant = Restaurant(fromJson: restaurantJson)
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
        if menuItem != nil{
        var dictionaryElements = [[String:Any]]()
        for menuItemElement in menuItem {
        	dictionaryElements.append(menuItemElement.toDictionary())
        }
        dictionary["menuItem"] = dictionaryElements
        }
        if restaurant != nil{
        	dictionary["restaurant"] = restaurant.toDictionary()
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
		menuItem = aDecoder.decodeObject(forKey: "menu_item") as? [MenuItem]
		restaurant = aDecoder.decodeObject(forKey: "restaurant") as? Restaurant
		review = aDecoder.decodeObject(forKey: "review") as? Review
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if menuItem != nil{
			aCoder.encode(menuItem, forKey: "menu_item")
		}
		if restaurant != nil{
			aCoder.encode(restaurant, forKey: "restaurant")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}

	}

}
