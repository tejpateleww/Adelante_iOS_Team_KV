//
//  Favorite.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 13, 2021

import Foundation
import SwiftyJSON


class Favorite : NSObject, NSCoding{

    var restaurant : [Restaurant]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        restaurant = [Restaurant]()
        let restaurantArray = json["restaurant"].arrayValue
        for restaurantJson in restaurantArray{
            let value = Restaurant(fromJson: restaurantJson)
            restaurant.append(value)
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
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		restaurant = aDecoder.decodeObject(forKey: "restaurant") as? [Restaurant]
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

	}

}
