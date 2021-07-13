//
//  ItemList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 13, 2021

import Foundation
import SwiftyJSON


class ItemList : NSObject, NSCoding{

    var cartItemId : String!
    var descriptionField : String!
    var id : String!
    var itemImg : String!
    var itemName : String!
    var outletId : String!
    var price : String!
    var qty : String!
    var quantity : String!
    var subTotal : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        cartItemId = json["cart_item_id"].stringValue
        descriptionField = json["description"].stringValue
        id = json["id"].stringValue
        itemImg = json["item_img"].stringValue
        itemName = json["item_name"].stringValue
        outletId = json["outlet_id"].stringValue
        price = json["price"].stringValue
        qty = json["qty"].stringValue
        quantity = json["quantity"].stringValue
        subTotal = json["sub_total"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if cartItemId != nil{
        	dictionary["cart_item_id"] = cartItemId
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if itemImg != nil{
        	dictionary["item_img"] = itemImg
        }
        if itemName != nil{
        	dictionary["item_name"] = itemName
        }
        if outletId != nil{
        	dictionary["outlet_id"] = outletId
        }
        if price != nil{
        	dictionary["price"] = price
        }
        if qty != nil{
        	dictionary["qty"] = qty
        }
        if quantity != nil{
        	dictionary["quantity"] = quantity
        }
        if subTotal != nil{
        	dictionary["sub_total"] = subTotal
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		cartItemId = aDecoder.decodeObject(forKey: "cart_item_id") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		itemImg = aDecoder.decodeObject(forKey: "item_img") as? String
		itemName = aDecoder.decodeObject(forKey: "item_name") as? String
		outletId = aDecoder.decodeObject(forKey: "outlet_id") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		qty = aDecoder.decodeObject(forKey: "qty") as? String
		quantity = aDecoder.decodeObject(forKey: "quantity") as? String
		subTotal = aDecoder.decodeObject(forKey: "sub_total") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if cartItemId != nil{
			aCoder.encode(cartItemId, forKey: "cart_item_id")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if itemImg != nil{
			aCoder.encode(itemImg, forKey: "item_img")
		}
		if itemName != nil{
			aCoder.encode(itemName, forKey: "item_name")
		}
		if outletId != nil{
			aCoder.encode(outletId, forKey: "outlet_id")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if qty != nil{
			aCoder.encode(qty, forKey: "qty")
		}
		if quantity != nil{
			aCoder.encode(quantity, forKey: "quantity")
		}
		if subTotal != nil{
			aCoder.encode(subTotal, forKey: "sub_total")
		}

	}

}
