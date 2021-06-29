//
//  SubOrder.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 9, 2021

import Foundation
import SwiftyJSON


class SubOrder : NSObject, NSCoding{

    var id : String!
    var image : String!
    var itemQuantity : String!
    var name : String!
    var price : String!
    var quantity : String!
    var subVariantId : String!
    var subVariantPrice : String!
    var variant : [orderVariant]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        id = json["id"].stringValue
        image = json["image"].stringValue
        itemQuantity = json["item_quantity"].stringValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        quantity = json["quantity"].stringValue
        subVariantId = json["sub_variant_id"].stringValue
        subVariantPrice = json["sub_variant_price"].stringValue
        variant = [orderVariant]()
        let variantArray = json["variant"].arrayValue
        for variantJson in variantArray{
            let value = orderVariant(fromJson: variantJson)
            variant.append(value)
        }
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
        if itemQuantity != nil{
        	dictionary["item_quantity"] = itemQuantity
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if price != nil{
        	dictionary["price"] = price
        }
        if quantity != nil{
        	dictionary["quantity"] = quantity
        }
        if subVariantId != nil{
        	dictionary["sub_variant_id"] = subVariantId
        }
        if subVariantPrice != nil{
        	dictionary["sub_variant_price"] = subVariantPrice
        }
        if variant != nil{
        var dictionaryElements = [[String:Any]]()
        for variantElement in variant {
        	dictionaryElements.append(variantElement.toDictionary())
        }
        dictionary["variant"] = dictionaryElements
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
		itemQuantity = aDecoder.decodeObject(forKey: "item_quantity") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		quantity = aDecoder.decodeObject(forKey: "quantity") as? String
		subVariantId = aDecoder.decodeObject(forKey: "sub_variant_id") as? String
		subVariantPrice = aDecoder.decodeObject(forKey: "sub_variant_price") as? String
		variant = aDecoder.decodeObject(forKey: "variant") as? [orderVariant]
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
		if itemQuantity != nil{
			aCoder.encode(itemQuantity, forKey: "item_quantity")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if quantity != nil{
			aCoder.encode(quantity, forKey: "quantity")
		}
		if subVariantId != nil{
			aCoder.encode(subVariantId, forKey: "sub_variant_id")
		}
		if subVariantPrice != nil{
			aCoder.encode(subVariantPrice, forKey: "sub_variant_price")
		}
		if variant != nil{
			aCoder.encode(variant, forKey: "variant")
		}

	}

}
