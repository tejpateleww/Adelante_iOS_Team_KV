//
//  MenuItem.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 16, 2021

import Foundation
import SwiftyJSON


class MenuItem : NSObject, NSCoding{

    var cartItemId : String!
    var cartQty : String!
    var categoryId : String!
    var createdAt : String!
    var descriptionField : String!
    var foodType : String!
    var id : String!
    var image : String!
    var name : String!
    var outletId : String!
    var price : String!
    var quantity : String!
    var restaurantId : String!
    var searchIndex : String!
    var size : String!
    var status : String!
    var time : String!
    var trash : String!
    var updatedAt : String!
    var userId : String!
    var variant : String!
    var vegNonveg : String!
    var viewCount : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        cartItemId = json["cart_item_id"].stringValue
        cartQty = json["cart_qty"].stringValue
        categoryId = json["category_id"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        foodType = json["food_type"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        outletId = json["outlet_id"].stringValue
        price = json["price"].stringValue
        quantity = json["quantity"].stringValue
        restaurantId = json["restaurant_id"].stringValue
        searchIndex = json["search_index"].stringValue
        size = json["size"].stringValue
        status = json["status"].stringValue
        time = json["time"].stringValue
        trash = json["trash"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].stringValue
        variant = json["variant"].stringValue
        vegNonveg = json["veg_nonveg"].stringValue
        viewCount = json["view_count"].stringValue
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
        if categoryId != nil{
        	dictionary["category_id"] = categoryId
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if foodType != nil{
        	dictionary["food_type"] = foodType
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
        if outletId != nil{
        	dictionary["outlet_id"] = outletId
        }
        if price != nil{
        	dictionary["price"] = price
        }
        if quantity != nil{
        	dictionary["quantity"] = quantity
        }
        if restaurantId != nil{
        	dictionary["restaurant_id"] = restaurantId
        }
        if searchIndex != nil{
        	dictionary["search_index"] = searchIndex
        }
        if size != nil{
        	dictionary["size"] = size
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if time != nil{
        	dictionary["time"] = time
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if updatedAt != nil{
        	dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
        	dictionary["user_id"] = userId
        }
        if variant != nil{
        	dictionary["variant"] = variant
        }
        if vegNonveg != nil{
        	dictionary["veg_nonveg"] = vegNonveg
        }
        if viewCount != nil{
        	dictionary["view_count"] = viewCount
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
		categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		foodType = aDecoder.decodeObject(forKey: "food_type") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		outletId = aDecoder.decodeObject(forKey: "outlet_id") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		quantity = aDecoder.decodeObject(forKey: "quantity") as? String
		restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
		searchIndex = aDecoder.decodeObject(forKey: "search_index") as? String
		size = aDecoder.decodeObject(forKey: "size") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		time = aDecoder.decodeObject(forKey: "time") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
		variant = aDecoder.decodeObject(forKey: "variant") as? String
		vegNonveg = aDecoder.decodeObject(forKey: "veg_nonveg") as? String
		viewCount = aDecoder.decodeObject(forKey: "view_count") as? String
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
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if foodType != nil{
			aCoder.encode(foodType, forKey: "food_type")
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
		if outletId != nil{
			aCoder.encode(outletId, forKey: "outlet_id")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if quantity != nil{
			aCoder.encode(quantity, forKey: "quantity")
		}
		if restaurantId != nil{
			aCoder.encode(restaurantId, forKey: "restaurant_id")
		}
		if searchIndex != nil{
			aCoder.encode(searchIndex, forKey: "search_index")
		}
		if size != nil{
			aCoder.encode(size, forKey: "size")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if time != nil{
			aCoder.encode(time, forKey: "time")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if variant != nil{
			aCoder.encode(variant, forKey: "variant")
		}
		if vegNonveg != nil{
			aCoder.encode(vegNonveg, forKey: "veg_nonveg")
		}
		if viewCount != nil{
			aCoder.encode(viewCount, forKey: "view_count")
		}

	}

}
