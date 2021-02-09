//
//  OutletData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 9, 2021

import Foundation
import SwiftyJSON


class OutletData : NSObject, NSCoding{

    var address : String!
    var createdAt : String!
    var days : String!
    var descriptionField : String!
    var distance : String!
    var favourite : String!
    var fromTime : String!
    var id : String!
    var image : String!
    var isKitchen : String!
    var isOutlet : String!
    var isQsr : String!
    var item : String!
    var lat : String!
    var lng : String!
    var name : String!
    var ratingCount : String!
    var restaurantId : String!
    var review : Int!
    var reviewCount : String!
    var serviceFee : String!
    var status : String!
    var storePolicy : String!
    var street : String!
    var tax : String!
    var toTime : String!
    var trash : String!
    var type : String!
    var updatedAt : String!
    var userId : String!
    var zipCode : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        createdAt = json["created_at"].stringValue
        days = json["days"].stringValue
        descriptionField = json["description"].stringValue
        distance = json["distance"].stringValue
        favourite = json["favourite"].stringValue
        fromTime = json["from_time"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        isKitchen = json["is_kitchen"].stringValue
        isOutlet = json["is_outlet"].stringValue
        isQsr = json["is_qsr"].stringValue
        item = json["item"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        name = json["name"].stringValue
        ratingCount = json["rating_count"].stringValue
        restaurantId = json["restaurant_id"].stringValue
        review = json["review"].intValue
        reviewCount = json["review_count"].stringValue
        serviceFee = json["service_fee"].stringValue
        status = json["status"].stringValue
        storePolicy = json["store_policy"].stringValue
        street = json["street"].stringValue
        tax = json["tax"].stringValue
        toTime = json["to_time"].stringValue
        trash = json["trash"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].stringValue
        zipCode = json["zip_code"].stringValue
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
        if days != nil{
        	dictionary["days"] = days
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if distance != nil{
        	dictionary["distance"] = distance
        }
        if favourite != nil{
        	dictionary["favourite"] = favourite
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
        if isKitchen != nil{
        	dictionary["is_kitchen"] = isKitchen
        }
        if isOutlet != nil{
        	dictionary["is_outlet"] = isOutlet
        }
        if isQsr != nil{
        	dictionary["is_qsr"] = isQsr
        }
        if item != nil{
        	dictionary["item"] = item
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
        if ratingCount != nil{
        	dictionary["rating_count"] = ratingCount
        }
        if restaurantId != nil{
        	dictionary["restaurant_id"] = restaurantId
        }
        if review != nil{
        	dictionary["review"] = review
        }
        if reviewCount != nil{
        	dictionary["review_count"] = reviewCount
        }
        if serviceFee != nil{
        	dictionary["service_fee"] = serviceFee
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if storePolicy != nil{
        	dictionary["store_policy"] = storePolicy
        }
        if street != nil{
        	dictionary["street"] = street
        }
        if tax != nil{
        	dictionary["tax"] = tax
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
		days = aDecoder.decodeObject(forKey: "days") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		favourite = aDecoder.decodeObject(forKey: "favourite") as? String
		fromTime = aDecoder.decodeObject(forKey: "from_time") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		isKitchen = aDecoder.decodeObject(forKey: "is_kitchen") as? String
		isOutlet = aDecoder.decodeObject(forKey: "is_outlet") as? String
		isQsr = aDecoder.decodeObject(forKey: "is_qsr") as? String
		item = aDecoder.decodeObject(forKey: "item") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		ratingCount = aDecoder.decodeObject(forKey: "rating_count") as? String
		restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
		review = aDecoder.decodeObject(forKey: "review") as? Int
		reviewCount = aDecoder.decodeObject(forKey: "review_count") as? String
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		storePolicy = aDecoder.decodeObject(forKey: "store_policy") as? String
		street = aDecoder.decodeObject(forKey: "street") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		toTime = aDecoder.decodeObject(forKey: "to_time") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		type = aDecoder.decodeObject(forKey: "type") as? String
		updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
		zipCode = aDecoder.decodeObject(forKey: "zip_code") as? String
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
		if days != nil{
			aCoder.encode(days, forKey: "days")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
		}
		if favourite != nil{
			aCoder.encode(favourite, forKey: "favourite")
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
		if isKitchen != nil{
			aCoder.encode(isKitchen, forKey: "is_kitchen")
		}
		if isOutlet != nil{
			aCoder.encode(isOutlet, forKey: "is_outlet")
		}
		if isQsr != nil{
			aCoder.encode(isQsr, forKey: "is_qsr")
		}
		if item != nil{
			aCoder.encode(item, forKey: "item")
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
		if ratingCount != nil{
			aCoder.encode(ratingCount, forKey: "rating_count")
		}
		if restaurantId != nil{
			aCoder.encode(restaurantId, forKey: "restaurant_id")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}
		if reviewCount != nil{
			aCoder.encode(reviewCount, forKey: "review_count")
		}
		if serviceFee != nil{
			aCoder.encode(serviceFee, forKey: "service_fee")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if storePolicy != nil{
			aCoder.encode(storePolicy, forKey: "store_policy")
		}
		if street != nil{
			aCoder.encode(street, forKey: "street")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
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

	}

}
