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
    var tax : String!
    var is_outlet : String!
    var is_qsr : String!
    var street : String!
    var delivery_type : String!
    var descriptionss : String!
    var rating_count : String!
    var lat : String!
    var service_fee : String!
    var is_kitchen : String!
    var store_policy : String!
    var parking_slot : String!
    var lng: String!
    var is_close: String!
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
        tax =  json["tax"].stringValue
        is_outlet =  json["is_outlet"].stringValue
        is_qsr =  json["is_qsr"].stringValue
        street =  json["street"].stringValue
        delivery_type =  json["delivery_type"].stringValue
        descriptionss =  json["description"].stringValue
        rating_count =  json["rating_count"].stringValue
        lat =  json["lat"].stringValue
        service_fee =  json["service_fee"].stringValue
        is_kitchen =  json["is_kitchen"].stringValue
        store_policy =  json["store_policy"].stringValue
        parking_slot =  json["parking_slot"].stringValue
        lng = json["lng"].stringValue
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
        if tax != nil {
            dictionary["tax"] = tax
        }
        if is_outlet != nil {
            dictionary["is_outlet"] = is_outlet
        }
        if is_qsr != nil {
            dictionary["is_qsr"] = is_qsr
        }
        if street != nil {
            dictionary["street"] = street
        }
        if delivery_type != nil {
            dictionary["delivery_type"] = delivery_type
        }
        if descriptionss != nil {
            dictionary["description"] = descriptionss
        }
        if rating_count != nil {
            dictionary["rating_count"] = rating_count
        }
        if lat != nil {
            dictionary["lat"] = lat
        }
        if service_fee != nil {
            dictionary["service_fee"] = service_fee
        }
        if is_kitchen != nil {
            dictionary["is_kitchen"] = is_kitchen
        }
        if store_policy != nil {
            dictionary["store_policy"] = store_policy
        }
        if parking_slot != nil {
            dictionary["parking_slot"] = parking_slot
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
        tax = aDecoder.decodeObject(forKey: "tax") as? String
        is_outlet = aDecoder.decodeObject(forKey: "is_outlet") as? String
        is_qsr = aDecoder.decodeObject(forKey: "is_qsr") as? String
        street = aDecoder.decodeObject(forKey: "street") as? String
        delivery_type = aDecoder.decodeObject(forKey: "delivery_type") as? String
        descriptionss = aDecoder.decodeObject(forKey: "descriptionss") as? String
        rating_count = aDecoder.decodeObject(forKey: "rating_count") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        service_fee = aDecoder.decodeObject(forKey: "service_fee") as? String
        is_kitchen = aDecoder.decodeObject(forKey: "is_kitchen") as? String
        store_policy = aDecoder.decodeObject(forKey: "store_policy") as? String
        parking_slot = aDecoder.decodeObject(forKey: "parking_slot") as? String
        
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
        if tax != nil {
            aCoder.encode(tax, forKey: "tax")
        }
        if is_outlet != nil {
            aCoder.encode(is_outlet, forKey: "is_outlet")
        }
        if is_qsr != nil {
            aCoder.encode(is_qsr, forKey: "is_qsr")
        }
        if street != nil {
            aCoder.encode(street, forKey: "street")
        }
        if delivery_type != nil {
            aCoder.encode(delivery_type, forKey: "delivery_type")
        }
        if descriptionss != nil {
            aCoder.encode(descriptionss, forKey: "descriptionss")
        }
        if rating_count != nil {
            aCoder.encode(rating_count, forKey: "rating_count")
        }
        if lat != nil {
            aCoder.encode(lat, forKey: "lat")
        }
        if service_fee != nil {
            aCoder.encode(service_fee, forKey: "service_fee")
        }
        if is_kitchen != nil {
            aCoder.encode(is_kitchen, forKey: "is_kitchen")
        }
        if store_policy != nil {
            aCoder.encode(store_policy, forKey: "store_policy")
        }
        if parking_slot != nil {
            aCoder.encode(parking_slot, forKey: "parking_slot")
        }
	}
}
