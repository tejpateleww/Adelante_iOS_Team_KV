//
//  orderListingData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class orderListingData : NSObject, NSCoding{

    var createdAt : String!
    var id : String!
    var image : String!
    var price : String!
    var restaurantItemName : String!
    var restaurantName : String!
    var total : String!
    var username : String!
    var address : String!
    var street : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        price = json["price"].stringValue
        restaurantItemName = json["restaurant_item_name"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        total = json["total"].stringValue
        username = json["username"].stringValue
        address = json["address"].stringValue
        street = json["street"].stringValue
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
        if image != nil{
        	dictionary["image"] = image
        }
        if price != nil{
        	dictionary["price"] = price
        }
        if restaurantItemName != nil{
        	dictionary["restaurant_item_name"] = restaurantItemName
        }
        if restaurantName != nil{
        	dictionary["restaurant_name"] = restaurantName
        }
        if total != nil{
        	dictionary["total"] = total
        }
        if username != nil{
        	dictionary["username"] = username
        }
        if address != nil{
            dictionary["address"] = address
        }
        if street != nil{
            dictionary["street"] = street
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
		image = aDecoder.decodeObject(forKey: "image") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		restaurantItemName = aDecoder.decodeObject(forKey: "restaurant_item_name") as? String
		restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
		total = aDecoder.decodeObject(forKey: "total") as? String
		username = aDecoder.decodeObject(forKey: "username") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        street = aDecoder.decodeObject(forKey: "street") as? String
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
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if restaurantItemName != nil{
			aCoder.encode(restaurantItemName, forKey: "restaurant_item_name")
		}
		if restaurantName != nil{
			aCoder.encode(restaurantName, forKey: "restaurant_name")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if street != nil{
            aCoder.encode(street, forKey: "street")
        }
	}

}
