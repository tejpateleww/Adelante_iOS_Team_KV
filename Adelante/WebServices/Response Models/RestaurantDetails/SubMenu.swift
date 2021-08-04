//
//  SubMenu.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 30, 2021

import Foundation
import SwiftyJSON


class SubMenu : NSObject, NSCoding{

    var cartItemId : String!
    var cartQty : String!
    var cartVariantCount : String!
    var category : String!
    var categoryId : String!
    var id : String!
    var image : String!
    var name : String!
    var price : String!
    var quantity : Int!
    var searchIndex : String!
    var size : String!
    var variant : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        cartItemId = json["cart_item_id"].stringValue
        cartQty = json["cart_qty"].stringValue
        cartVariantCount = json["cart_variant_count"].stringValue
        category = json["category"].stringValue
        categoryId = json["category_id"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        quantity = json["quantity"].intValue
        searchIndex = json["search_index"].stringValue
        size = json["size"].stringValue
        variant = json["variant"].stringValue
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
        if cartQty != nil{
        	dictionary["cart_qty"] = cartQty
        }
        if cartVariantCount != nil{
        	dictionary["cart_variant_count"] = cartVariantCount
        }
        if category != nil{
        	dictionary["category"] = category
        }
        if categoryId != nil{
        	dictionary["category_id"] = categoryId
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
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
        if searchIndex != nil{
        	dictionary["search_index"] = searchIndex
        }
        if size != nil{
        	dictionary["size"] = size
        }
        if variant != nil{
        	dictionary["variant"] = variant
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
		cartQty = aDecoder.decodeObject(forKey: "cart_qty") as? String
		cartVariantCount = aDecoder.decodeObject(forKey: "cart_variant_count") as? String
		category = aDecoder.decodeObject(forKey: "category") as? String
		categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		quantity = aDecoder.decodeObject(forKey: "quantity") as? Int
		searchIndex = aDecoder.decodeObject(forKey: "search_index") as? String
		size = aDecoder.decodeObject(forKey: "size") as? String
		variant = aDecoder.decodeObject(forKey: "variant") as? String
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
		if cartQty != nil{
			aCoder.encode(cartQty, forKey: "cart_qty")
		}
		if cartVariantCount != nil{
			aCoder.encode(cartVariantCount, forKey: "cart_variant_count")
		}
		if category != nil{
			aCoder.encode(category, forKey: "category")
		}
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
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
		if searchIndex != nil{
			aCoder.encode(searchIndex, forKey: "search_index")
		}
		if size != nil{
			aCoder.encode(size, forKey: "size")
		}
		if variant != nil{
			aCoder.encode(variant, forKey: "variant")
		}

	}

}
