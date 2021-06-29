//
//  MainOrder.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class MainOrder : NSObject, NSCoding{

    var address : String!
    var createdAt : String!
    var date : String!
    var item : [Item]!
    var itemQuantity : String!
    var orderId : String!
    var restaurantItemName : String!
    var restaurantName : String!
    var serviceFee : String!
    var tax : String!
    var total : String!
    var username : String!
    var sub_total : String!
    var street : String!
    var qrcode : String!
    var restaurant_id : String!
    var main_order_id : String!
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        createdAt = json["created_at"].stringValue
        date = json["date"].stringValue
        item = [Item]()
        let itemArray = json["item"].arrayValue
        for itemJson in itemArray{
            let value = Item(fromJson: itemJson)
            item.append(value)
        }
        itemQuantity = json["item_quantity"].stringValue
        orderId = json["order_id"].stringValue
        restaurantItemName = json["restaurant_item_name"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        serviceFee = json["service_fee"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].stringValue
        username = json["username"].stringValue
        sub_total = json["sub_total"].stringValue
        street = json["street"].stringValue
        qrcode = json["qrcode"].stringValue
        restaurant_id = json["restaurant_id"].stringValue
        main_order_id = json["main_order_id"].stringValue
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
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if date != nil{
        	dictionary["date"] = date
        }
        if item != nil{
        var dictionaryElements = [[String:Any]]()
        for itemElement in item {
        	dictionaryElements.append(itemElement.toDictionary())
        }
        dictionary["item"] = dictionaryElements
        }
        if itemQuantity != nil{
        	dictionary["item_quantity"] = itemQuantity
        }
        if orderId != nil{
        	dictionary["order_id"] = orderId
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
        if tax != nil{
        	dictionary["tax"] = tax
        }
        if total != nil{
        	dictionary["total"] = total
        }
        if username != nil{
        	dictionary["username"] = username
        }
        if sub_total != nil{
            dictionary["sub_total"] = sub_total
        }
        if street != nil{
            dictionary["street"] = street
        }
        if qrcode != nil{
            dictionary["qrcode"] = qrcode
        }
        if restaurant_id != nil{
            dictionary["restaurant_id"] = restaurant_id
        }
        if main_order_id != nil{
            dictionary["main_order_id"] = main_order_id
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
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		date = aDecoder.decodeObject(forKey: "date") as? String
		item = aDecoder.decodeObject(forKey: "item") as? [Item]
		itemQuantity = aDecoder.decodeObject(forKey: "item_quantity") as? String
		orderId = aDecoder.decodeObject(forKey: "order_id") as? String
		restaurantItemName = aDecoder.decodeObject(forKey: "restaurant_item_name") as? String
		restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		total = aDecoder.decodeObject(forKey: "total") as? String
		username = aDecoder.decodeObject(forKey: "username") as? String
        sub_total = aDecoder.decodeObject(forKey: "sub_total") as? String
        street = aDecoder.decodeObject(forKey: "street") as? String
        qrcode = aDecoder.decodeObject(forKey: "qrcode") as? String
        restaurant_id = aDecoder.decodeObject(forKey: "restaurant_id") as? String
        main_order_id = aDecoder.decodeObject(forKey: "main_order_id") as? String
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
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if date != nil{
			aCoder.encode(date, forKey: "date")
		}
		if item != nil{
			aCoder.encode(item, forKey: "item")
		}
		if itemQuantity != nil{
			aCoder.encode(itemQuantity, forKey: "item_quantity")
		}
		if orderId != nil{
			aCoder.encode(orderId, forKey: "order_id")
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
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}
        if sub_total != nil{
            aCoder.encode(sub_total, forKey: "sub_total")
        }
        if street != nil{
            aCoder.encode(street, forKey: "street")
        }
        if qrcode != nil{
            aCoder.encode(qrcode, forKey: "qrcode")
        }
        if restaurant_id != nil{
            aCoder.encode(restaurant_id, forKey: "restaurant_id")
        }
        if main_order_id != nil{
            aCoder.encode(main_order_id, forKey: "main_order_id")
        }
	}

}
