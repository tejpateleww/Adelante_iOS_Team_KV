//
//  Item.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class Item : NSObject, NSCoding{

    var id : String!
    var image : String!
    var mainOrderId : String!
    var price : String!
    var quantity : String!
    var restaurantItemName : String!
    var subTotal : String!
    var date : String!
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        id = json["id"].stringValue
        image = json["image"].stringValue
        mainOrderId = json["main_order_id"].stringValue
        price = json["price"].stringValue
        quantity = json["quantity"].stringValue
        restaurantItemName = json["restaurant_item_name"].stringValue
        subTotal = json["sub_total"].stringValue
        date = json["date"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if mainOrderId != nil{
        	dictionary["main_order_id"] = mainOrderId
        }
        if price != nil{
        	dictionary["price"] = price
        }
        if quantity != nil{
        	dictionary["quantity"] = quantity
        }
        if restaurantItemName != nil{
        	dictionary["restaurant_item_name"] = restaurantItemName
        }
        if subTotal != nil{
        	dictionary["sub_total"] = subTotal
        }
        if date != nil{
            dictionary["date"] = date
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		mainOrderId = aDecoder.decodeObject(forKey: "main_order_id") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		quantity = aDecoder.decodeObject(forKey: "quantity") as? String
		restaurantItemName = aDecoder.decodeObject(forKey: "restaurant_item_name") as? String
		subTotal = aDecoder.decodeObject(forKey: "sub_total") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if mainOrderId != nil{
			aCoder.encode(mainOrderId, forKey: "main_order_id")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if quantity != nil{
			aCoder.encode(quantity, forKey: "quantity")
		}
		if restaurantItemName != nil{
			aCoder.encode(restaurantItemName, forKey: "restaurant_item_name")
		}
		if subTotal != nil{
			aCoder.encode(subTotal, forKey: "sub_total")
		}
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
	}

}
