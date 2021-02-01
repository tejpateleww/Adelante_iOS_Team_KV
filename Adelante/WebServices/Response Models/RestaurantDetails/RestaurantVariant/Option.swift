//
//  Option.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 1, 2021

import Foundation
import SwiftyJSON


class Option : NSObject, NSCoding{

    var createdAt : String!
    var id : String!
    var menuChoice : String!
    var name : String!
    var price : String!
    var restaurantItemId : String!
    var status : String!
    var trash : String!
    var variantId : String!
    var variantName : String!
    var isSelected : Bool = false

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        menuChoice = json["menu_choice"].stringValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        restaurantItemId = json["restaurant_item_id"].stringValue
        status = json["status"].stringValue
        trash = json["trash"].stringValue
        variantId = json["variant_id"].stringValue
        variantName = json["variant_name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if menuChoice != nil{
        	dictionary["menu_choice"] = menuChoice
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if price != nil{
        	dictionary["price"] = price
        }
        if restaurantItemId != nil{
        	dictionary["restaurant_item_id"] = restaurantItemId
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if variantId != nil{
        	dictionary["variant_id"] = variantId
        }
        if variantName != nil{
        	dictionary["variant_name"] = variantName
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		menuChoice = aDecoder.decodeObject(forKey: "menu_choice") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		restaurantItemId = aDecoder.decodeObject(forKey: "restaurant_item_id") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		variantId = aDecoder.decodeObject(forKey: "variant_id") as? String
		variantName = aDecoder.decodeObject(forKey: "variant_name") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if menuChoice != nil{
			aCoder.encode(menuChoice, forKey: "menu_choice")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if restaurantItemId != nil{
			aCoder.encode(restaurantItemId, forKey: "restaurant_item_id")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if variantId != nil{
			aCoder.encode(variantId, forKey: "variant_id")
		}
		if variantName != nil{
			aCoder.encode(variantName, forKey: "variant_name")
		}

	}

}
