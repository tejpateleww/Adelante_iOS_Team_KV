//
//  updateCartResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 13, 2021

import Foundation
import SwiftyJSON


class updateCartResModel : NSObject, NSCoding{

    var data : updateQtyDatum!
    var message : String!
    var restaurant : updateQtyRestaurant!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = updateQtyDatum(fromJson: dataJson)
        }
        message = json["message"].stringValue
        let restaurantJson = json["restaurant"]
        if !restaurantJson.isEmpty{
            restaurant = updateQtyRestaurant(fromJson: restaurantJson)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if data != nil{
        	dictionary["data"] = data.toDictionary()
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if restaurant != nil{
        	dictionary["restaurant"] = restaurant.toDictionary()
        }
        if status != nil{
        	dictionary["status"] = status
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		data = aDecoder.decodeObject(forKey: "data") as? updateQtyDatum
		message = aDecoder.decodeObject(forKey: "message") as? String
		restaurant = aDecoder.decodeObject(forKey: "restaurant") as? updateQtyRestaurant
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if restaurant != nil{
			aCoder.encode(restaurant, forKey: "restaurant")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
