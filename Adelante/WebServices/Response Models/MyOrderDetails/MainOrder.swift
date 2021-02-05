//
//  MainOrder.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class MainOrder : NSObject, NSCoding{

    var createdAt : String!
    var id : String!
    var image : String!
    var price : String!
    var restaurantItemName : String!
    var restaurantName : String!
    var subOrder : [SubOrder]!
    var total : String!
    var username : String!

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
        subOrder = [SubOrder]()
        let subOrderArray = json["sub_order"].arrayValue
        for subOrderJson in subOrderArray{
            let value = SubOrder(fromJson: subOrderJson)
            subOrder.append(value)
        }
        total = json["total"].stringValue
        username = json["username"].stringValue
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
        if subOrder != nil{
        var dictionaryElements = [[String:Any]]()
        for subOrderElement in subOrder {
        	dictionaryElements.append(subOrderElement.toDictionary())
        }
        dictionary["subOrder"] = dictionaryElements
        }
        if total != nil{
        	dictionary["total"] = total
        }
        if username != nil{
        	dictionary["username"] = username
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
		subOrder = aDecoder.decodeObject(forKey: "sub_order") as? [SubOrder]
		total = aDecoder.decodeObject(forKey: "total") as? String
		username = aDecoder.decodeObject(forKey: "username") as? String
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
		if subOrder != nil{
			aCoder.encode(subOrder, forKey: "sub_order")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}

	}

}
