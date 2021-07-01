//
//  SearchRestaurantItem.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 1, 2021

import Foundation
import SwiftyJSON


class SearchRestaurantItem : NSObject, NSCoding{

    var descriptionField : String!
    var dist : Float!
    var distance : String!
    var favourite : String!
    var id : String!
    var image : String!
    var itemId : String!
    var lat : String!
    var lng : String!
    var name : String!
    var price : String!
    var quantity : String!
    var ratingCount : Double!
    var restaurantName : String!
    var review : Int!
    var size : String!
    var type : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        descriptionField = json["description"].stringValue
        dist = json["dist"].floatValue
        distance = json["distance"].stringValue
        favourite = json["favourite"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        itemId = json["item_id"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        quantity = json["quantity"].stringValue
        ratingCount = json["rating_count"].doubleValue
        restaurantName = json["restaurant_name"].stringValue
        review = json["review"].intValue
        size = json["size"].stringValue
        type = json["type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if dist != nil{
        	dictionary["dist"] = dist
        }
        if distance != nil{
        	dictionary["distance"] = distance
        }
        if favourite != nil{
        	dictionary["favourite"] = favourite
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if itemId != nil{
        	dictionary["item_id"] = itemId
        }
        if lat != nil{
        	dictionary["lat"] = lat
        }
        if lng != nil{
        	dictionary["lng"] = lng
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
        if ratingCount != nil{
        	dictionary["rating_count"] = ratingCount
        }
        if restaurantName != nil{
        	dictionary["restaurant_name"] = restaurantName
        }
        if review != nil{
        	dictionary["review"] = review
        }
        if size != nil{
        	dictionary["size"] = size
        }
        if type != nil{
        	dictionary["type"] = type
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		dist = aDecoder.decodeObject(forKey: "dist") as? Float
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		favourite = aDecoder.decodeObject(forKey: "favourite") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		itemId = aDecoder.decodeObject(forKey: "item_id") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
		quantity = aDecoder.decodeObject(forKey: "quantity") as? String
		ratingCount = aDecoder.decodeObject(forKey: "rating_count") as? Double
		restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
		review = aDecoder.decodeObject(forKey: "review") as? Int
		size = aDecoder.decodeObject(forKey: "size") as? String
		type = aDecoder.decodeObject(forKey: "type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if dist != nil{
			aCoder.encode(dist, forKey: "dist")
		}
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
		}
		if favourite != nil{
			aCoder.encode(favourite, forKey: "favourite")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if itemId != nil{
			aCoder.encode(itemId, forKey: "item_id")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
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
		if ratingCount != nil{
			aCoder.encode(ratingCount, forKey: "rating_count")
		}
		if restaurantName != nil{
			aCoder.encode(restaurantName, forKey: "restaurant_name")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}
		if size != nil{
			aCoder.encode(size, forKey: "size")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}

	}

}
