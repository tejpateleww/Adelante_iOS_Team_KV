//
//  SearchDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 1, 2021

import Foundation
import SwiftyJSON


class SearchDatum : NSObject, NSCoding{

    var restaurant : [SearchRestaurant]!
    var restaurantItem : [SearchRestaurantItem]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        restaurant = [SearchRestaurant]()
        let restaurantArray = json["restaurant"].arrayValue
        for restaurantJson in restaurantArray{
            let value = SearchRestaurant(fromJson: restaurantJson)
            restaurant.append(value)
        }
        restaurantItem = [SearchRestaurantItem]()
        let restaurantItemArray = json["restaurant_item"].arrayValue
        for restaurantItemJson in restaurantItemArray{
            let value = SearchRestaurantItem(fromJson: restaurantItemJson)
            restaurantItem.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if restaurant != nil{
        var dictionaryElements = [[String:Any]]()
        for restaurantElement in restaurant {
        	dictionaryElements.append(restaurantElement.toDictionary())
        }
        dictionary["restaurant"] = dictionaryElements
        }
        if restaurantItem != nil{
        var dictionaryElements = [[String:Any]]()
        for restaurantItemElement in restaurantItem {
        	dictionaryElements.append(restaurantItemElement.toDictionary())
        }
        dictionary["restaurantItem"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		restaurant = aDecoder.decodeObject(forKey: "restaurant") as? [SearchRestaurant]
		restaurantItem = aDecoder.decodeObject(forKey: "restaurant_item") as? [SearchRestaurantItem]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if restaurant != nil{
			aCoder.encode(restaurant, forKey: "restaurant")
		}
		if restaurantItem != nil{
			aCoder.encode(restaurantItem, forKey: "restaurant_item")
		}

	}

}
