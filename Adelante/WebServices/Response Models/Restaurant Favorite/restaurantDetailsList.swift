//
//  restaurantDetailsList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 18, 2021

import Foundation
import SwiftyJSON


class restaurantDetailsList : NSObject, NSCoding{

    var restaurantDetails : [RestaurantFavorite]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        restaurantDetails = [RestaurantFavorite]()
        let restaurantArray = json["restaurant"].arrayValue
        for restaurantJson in restaurantArray{
            let value = RestaurantFavorite(fromJson: restaurantJson)
            restaurantDetails.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if restaurantDetails != nil{
        var dictionaryElements = [[String:Any]]()
        for restaurantElement in restaurantDetails {
        	dictionaryElements.append(restaurantElement.toDictionary())
        }
        dictionary["restaurantDetails"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        restaurantDetails = aDecoder.decodeObject(forKey: "restaurant") as? [RestaurantFavorite]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if restaurantDetails != nil{
			aCoder.encode(restaurantDetails, forKey: "restaurantDetails")
		}

	}

}
