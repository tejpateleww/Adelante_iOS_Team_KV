//
//  SearchRestaurant.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 1, 2021

import Foundation
import SwiftyJSON


class SearchRestaurant : NSObject, NSCoding{

    var address : String!
    var createdAt : String!
    var days : String!
    var deliveryType : String!
    var descriptionField : String!
    var dist : Float!
    var distance : String!
    var favourite : String!
    var fromTime : String!
    var id : String!
    var image : String!
    var isKitchen : String!
    var isOutlet : String!
    var isQsr : String!
    var lat : String!
    var lng : String!
    var name : String!
    var parkingSlot : String!
    var ratingCount : Int!
    var restaurantId : String!
    var review : Int!
    var serviceFee : String!
    var status : String!
    var storePolicy : String!
    var street : String!
    var tax : String!
    var timeZone : String!
    var toTime : String!
    var trash : String!
    var type : String!
    var updatedAt : String!
    var userId : String!
    var zipCode : String!
    var is_close: String!

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
        deliveryType = json["delivery_type"].stringValue
        descriptionField = json["description"].stringValue
        dist = json["dist"].floatValue
        distance = json["distance"].stringValue
        favourite = json["favourite"].stringValue
        fromTime = json["from_time"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        isKitchen = json["is_kitchen"].stringValue
        isOutlet = json["is_outlet"].stringValue
        isQsr = json["is_qsr"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        name = json["name"].stringValue
        parkingSlot = json["parking_slot"].stringValue
        ratingCount = json["rating_count"].intValue
        restaurantId = json["restaurant_id"].stringValue
        review = json["review"].intValue
        serviceFee = json["service_fee"].stringValue
        status = json["status"].stringValue
        storePolicy = json["store_policy"].stringValue
        street = json["street"].stringValue
        tax = json["tax"].stringValue
        timeZone = json["time_zone"].stringValue
        toTime = json["to_time"].stringValue
        trash = json["trash"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].stringValue
        zipCode = json["zip_code"].stringValue
        is_close = json["is_close"].stringValue
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
        if deliveryType != nil{
        	dictionary["delivery_type"] = deliveryType
        }
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
        if lat != nil{
        	dictionary["lat"] = lat
        }
        if lng != nil{
        	dictionary["lng"] = lng
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if parkingSlot != nil{
        	dictionary["parking_slot"] = parkingSlot
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
        if timeZone != nil{
        	dictionary["time_zone"] = timeZone
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
		deliveryType = aDecoder.decodeObject(forKey: "delivery_type") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		dist = aDecoder.decodeObject(forKey: "dist") as? Float
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		favourite = aDecoder.decodeObject(forKey: "favourite") as? String
		fromTime = aDecoder.decodeObject(forKey: "from_time") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		isKitchen = aDecoder.decodeObject(forKey: "is_kitchen") as? String
		isOutlet = aDecoder.decodeObject(forKey: "is_outlet") as? String
		isQsr = aDecoder.decodeObject(forKey: "is_qsr") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		parkingSlot = aDecoder.decodeObject(forKey: "parking_slot") as? String
		ratingCount = aDecoder.decodeObject(forKey: "rating_count") as? Int
		restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
		review = aDecoder.decodeObject(forKey: "review") as? Int
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		storePolicy = aDecoder.decodeObject(forKey: "store_policy") as? String
		street = aDecoder.decodeObject(forKey: "street") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		timeZone = aDecoder.decodeObject(forKey: "time_zone") as? String
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
		if deliveryType != nil{
			aCoder.encode(deliveryType, forKey: "delivery_type")
		}
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
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if parkingSlot != nil{
			aCoder.encode(parkingSlot, forKey: "parking_slot")
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
		if timeZone != nil{
			aCoder.encode(timeZone, forKey: "time_zone")
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
