//
//  SubOrder.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class SubOrder : NSObject, NSCoding{

    var address : String!
    var id : String!
    var image : String!
    var mainOrderId : String!
    var restaurantItemName : String!
    var restaurantName : String!
    var serviceFee : String!
    var subTotal : String!
    var tax : String!
    var total : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        mainOrderId = json["main_order_id"].stringValue
        restaurantItemName = json["restaurant_item_name"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        serviceFee = json["service_fee"].stringValue
        subTotal = json["sub_total"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if address != nil{
        	dictionary["address"] = address
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if mainOrderId != nil{
        	dictionary["main_order_id"] = mainOrderId
        }
        if restaurantItemName != nil{
        	dictionary["restaurant_item_name"] = restaurantItemName
        }
        if restaurantName != nil{
        	dictionary["restaurant_name"] = restaurantName
        }
        if serviceFee != nil{
        	dictionary["service_fee"] = serviceFee
        }
        if subTotal != nil{
        	dictionary["sub_total"] = subTotal
        }
        if tax != nil{
        	dictionary["tax"] = tax
        }
        if total != nil{
        	dictionary["total"] = total
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		address = aDecoder.decodeObject(forKey: "address") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		mainOrderId = aDecoder.decodeObject(forKey: "main_order_id") as? String
		restaurantItemName = aDecoder.decodeObject(forKey: "restaurant_item_name") as? String
		restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		subTotal = aDecoder.decodeObject(forKey: "sub_total") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		total = aDecoder.decodeObject(forKey: "total") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if mainOrderId != nil{
			aCoder.encode(mainOrderId, forKey: "main_order_id")
		}
		if restaurantItemName != nil{
			aCoder.encode(restaurantItemName, forKey: "restaurant_item_name")
		}
		if restaurantName != nil{
			aCoder.encode(restaurantName, forKey: "restaurant_name")
		}
		if serviceFee != nil{
			aCoder.encode(serviceFee, forKey: "service_fee")
		}
		if subTotal != nil{
			aCoder.encode(subTotal, forKey: "sub_total")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}

	}

}
