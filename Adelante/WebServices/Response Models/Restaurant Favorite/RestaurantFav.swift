//
//  RestaurantFav.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 13, 2021

import Foundation
import SwiftyJSON


class RestaurantFav : NSObject, NSCoding{

    var createdAt : String!
    var distance : String!
    var id : String!
    var image : String!
    var name : String!
    var restaurantId : String!
    var review : String!
    var status : String!
    var subCategoryId : String!
    var userId : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        createdAt = json["created_at"].stringValue
        distance = json["distance"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        restaurantId = json["restaurant_id"].stringValue
        review = json["review"].stringValue
        status = json["status"].stringValue
        subCategoryId = json["sub_category_id"].stringValue
        userId = json["user_id"].stringValue
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
        if distance != nil{
        	dictionary["distance"] = distance
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
        if restaurantId != nil{
        	dictionary["restaurant_id"] = restaurantId
        }
        if review != nil{
        	dictionary["review"] = review
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if subCategoryId != nil{
        	dictionary["sub_category_id"] = subCategoryId
        }
        if userId != nil{
        	dictionary["user_id"] = userId
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
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
		review = aDecoder.decodeObject(forKey: "review") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		subCategoryId = aDecoder.decodeObject(forKey: "sub_category_id") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
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
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
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
		if restaurantId != nil{
			aCoder.encode(restaurantId, forKey: "restaurant_id")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if subCategoryId != nil{
			aCoder.encode(subCategoryId, forKey: "sub_category_id")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
