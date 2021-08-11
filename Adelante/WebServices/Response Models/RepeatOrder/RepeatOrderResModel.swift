//
//  repeatOrderResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 11, 2021

import Foundation
import SwiftyJSON


class repeatOrderResModel : NSObject, NSCoding{

    var cartId : Int!
    var message : String!
    var restaurantId : Int!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        cartId = json["cart_id"].intValue
        message = json["message"].stringValue
        restaurantId = json["restaurant_id"].intValue
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if cartId != nil{
        	dictionary["cart_id"] = cartId
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if restaurantId != nil{
        	dictionary["restaurant_id"] = restaurantId
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
		cartId = aDecoder.decodeObject(forKey: "cart_id") as? Int
		message = aDecoder.decodeObject(forKey: "message") as? String
		restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? Int
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if cartId != nil{
			aCoder.encode(cartId, forKey: "cart_id")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if restaurantId != nil{
			aCoder.encode(restaurantId, forKey: "restaurant_id")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
