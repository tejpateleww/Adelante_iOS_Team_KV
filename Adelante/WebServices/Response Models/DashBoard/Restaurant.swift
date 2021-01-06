//
//  Restaurant.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 6, 2021

import Foundation
import SwiftyJSON


class Restaurant : NSObject, NSCoding{

    var address : String!
    var bannerId : String!
    var createdAt : String!
    var id : String!
    var image : String!
    var name : String!
    var status : String!
    var trash : String!
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
        bannerId = json["banner_id"].stringValue
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        status = json["status"].stringValue
        trash = json["trash"].stringValue
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
        if bannerId != nil{
        	dictionary["banner_id"] = bannerId
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
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
        if status != nil{
        	dictionary["status"] = status
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
		bannerId = aDecoder.decodeObject(forKey: "banner_id") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
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
		if bannerId != nil{
			aCoder.encode(bannerId, forKey: "banner_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
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
		if status != nil{
			aCoder.encode(status, forKey: "status")
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
		if zipCode != nil{
			aCoder.encode(zipCode, forKey: "zip_code")
		}

	}

}
