//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 17, 2020

import Foundation
import SwiftyJSON


class ResProfileDatum : NSObject, NSCoding{

    var createdAt : String!
    var deviceToken : String!
    var deviceType : String!
    var email : String!
    var firstName : String!
    var id : String!
    var image : String!
    var lastName : String!
    var lat : String!
    var lng : String!
    var mobileNo : String!
    var password : String!
    var rememberToken : String!
    var socialId : String!
    var socialType : String!
    var status : String!
    var trash : String!
    var xApiKey : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!) {
		if json.isEmpty{
			return
		}
        createdAt = json["created_at"].stringValue
        deviceToken = json["device_token"].stringValue
        deviceType = json["device_type"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        lastName = json["last_name"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        mobileNo = json["mobile_no"].stringValue
        password = json["password"].stringValue
        rememberToken = json["remember_token"].stringValue
        socialId = json["social_id"].stringValue
        socialType = json["social_type"].stringValue
        status = json["status"].stringValue
        trash = json["trash"].stringValue
        xApiKey = json["x-api-key"].stringValue
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
        if deviceToken != nil{
        	dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
        	dictionary["device_type"] = deviceType
        }
        if email != nil{
        	dictionary["email"] = email
        }
        if firstName != nil{
        	dictionary["first_name"] = firstName
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if lastName != nil{
        	dictionary["last_name"] = lastName
        }
        if lat != nil{
        	dictionary["lat"] = lat
        }
        if lng != nil{
        	dictionary["lng"] = lng
        }
        if mobileNo != nil{
        	dictionary["mobile_no"] = mobileNo
        }
        if password != nil{
        	dictionary["password"] = password
        }
        if rememberToken != nil{
        	dictionary["remember_token"] = rememberToken
        }
        if socialId != nil{
        	dictionary["social_id"] = socialId
        }
        if socialType != nil{
        	dictionary["social_type"] = socialType
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if xApiKey != nil{
        	dictionary["x-api-key"] = xApiKey
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
		deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
		deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
		email = aDecoder.decodeObject(forKey: "email") as? String
		firstName = aDecoder.decodeObject(forKey: "first_name") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		lastName = aDecoder.decodeObject(forKey: "last_name") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		mobileNo = aDecoder.decodeObject(forKey: "mobile_no") as? String
		password = aDecoder.decodeObject(forKey: "password") as? String
		rememberToken = aDecoder.decodeObject(forKey: "remember_token") as? String
		socialId = aDecoder.decodeObject(forKey: "social_id") as? String
		socialType = aDecoder.decodeObject(forKey: "social_type") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		xApiKey = aDecoder.decodeObject(forKey: "x-api-key") as? String
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
		if deviceToken != nil{
			aCoder.encode(deviceToken, forKey: "device_token")
		}
		if deviceType != nil{
			aCoder.encode(deviceType, forKey: "device_type")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if mobileNo != nil{
			aCoder.encode(mobileNo, forKey: "mobile_no")
		}
		if password != nil{
			aCoder.encode(password, forKey: "password")
		}
		if rememberToken != nil{
			aCoder.encode(rememberToken, forKey: "remember_token")
		}
		if socialId != nil{
			aCoder.encode(socialId, forKey: "social_id")
		}
		if socialType != nil{
			aCoder.encode(socialType, forKey: "social_type")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if xApiKey != nil{
			aCoder.encode(xApiKey, forKey: "x-api-key")
		}

	}

}
