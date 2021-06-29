//
//  RestaurantDetailsData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 27, 2021

import Foundation
import SwiftyJSON


class RestaurantDetailsData : NSObject, NSCoding{

    var restaurant : Restaurantinfo!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let restaurantJson = json["restaurant"]
        if !restaurantJson.isEmpty{
            restaurant = Restaurantinfo(fromJson: restaurantJson)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if restaurant != nil{
        	dictionary["restaurant"] = restaurant.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		restaurant = aDecoder.decodeObject(forKey: "restaurant") as? Restaurantinfo
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
