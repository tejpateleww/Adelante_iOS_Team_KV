//
//  Restaurant.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 7, 2021

import Foundation
import SwiftyJSON


class Restaurant : NSObject, NSCoding{

    var address : String!
    var bannerId : String!
    var createdAt : String!
    var days : String!
    var fromTime : String!
    var id : String!
    var image : String!
    var item : String!
    var name : String!
    var status : String!
    var toTime : String!
    var trash : String!
    var type : String!
    var updatedAt : String!
    var userId : String!
    var zipCode : String!
    var favourite : String!
    var distance : String!
    var review : String!
    var restaurant_id : String!
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        bannerId = json["banner_id"].stringValue
        createdAt = json["created_at"].stringValue
        days = json["days"].stringValue
        fromTime = json["from_time"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        item = json["item"].stringValue
        name = json["name"].stringValue
        status = json["status"].stringValue
        toTime = json["to_time"].stringValue
        trash = json["trash"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].stringValue
        zipCode = json["zip_code"].stringValue
        favourite = json["favourite"].stringValue
        distance = json["distance"].stringValue
        review = json["review"].stringValue
        restaurant_id = json["restaurant_id"].stringValue
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
        if bannerId != nil{
        	dictionary["banner_id"] = bannerId
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if days != nil{
        	dictionary["days"] = days
        }
        if fromTime != nil{
        	dictionary["from_time"] = fromTime
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if item != nil{
        	dictionary["item"] = item
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if toTime != nil{
        	dictionary["to_time"] = toTime
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if type != nil{
        	dictionary["type"] = type
        }
        if updatedAt != nil{
        	dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
        	dictionary["user_id"] = userId
        }
        if zipCode != nil{
        	dictionary["zip_code"] = zipCode
        }
        if favourite != nil{
            dictionary["favourite"] = updatedAt
        }
        if distance != nil{
            dictionary["distance"] = userId
        }
        if review != nil{
            dictionary["review"] = zipCode
        }
        if restaurant_id != nil{
            dictionary["restaurant_id"] = restaurant_id
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
		bannerId = aDecoder.decodeObject(forKey: "banner_id") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		days = aDecoder.decodeObject(forKey: "days") as? String
		fromTime = aDecoder.decodeObject(forKey: "from_time") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		item = aDecoder.decodeObject(forKey: "item") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		toTime = aDecoder.decodeObject(forKey: "to_time") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		type = aDecoder.decodeObject(forKey: "type") as? String
		updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
		zipCode = aDecoder.decodeObject(forKey: "zip_code") as? String
        favourite = aDecoder.decodeObject(forKey: "favourite") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        review = aDecoder.decodeObject(forKey: "review") as? String
        restaurant_id = aDecoder.decodeObject(forKey: "restaurant_id") as? String
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
		if bannerId != nil{
			aCoder.encode(bannerId, forKey: "banner_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if days != nil{
			aCoder.encode(days, forKey: "days")
		}
		if fromTime != nil{
			aCoder.encode(fromTime, forKey: "from_time")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if item != nil{
			aCoder.encode(item, forKey: "item")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if toTime != nil{
			aCoder.encode(toTime, forKey: "to_time")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if zipCode != nil{
			aCoder.encode(zipCode, forKey: "zip_code")
		}
        if favourite != nil{
            aCoder.encode(favourite, forKey: "favourite")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if review != nil{
            aCoder.encode(review, forKey: "review")
        }
        if restaurant_id != nil{
            aCoder.encode(restaurant_id, forKey: "restaurant_id")
        }
	}

}
