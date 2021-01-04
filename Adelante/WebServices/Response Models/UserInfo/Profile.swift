//
//  Profile.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 4, 2021

import Foundation
import SwiftyJSON


class Profile : NSObject, NSCoding{

    var activationCode : String!
    var activationSelector : String!
    var active : String!
    var apiKey : String!
    var createdOn : String!
    var deletedAt : String!
    var deviceToken : String!
    var deviceType : String!
    var email : String!
    var firstName : String!
    var forgottenPasswordCode : String!
    var forgottenPasswordSelector : String!
    var forgottenPasswordTime : String!
    var fullName : String!
    var id : String!
    var ipAddress : String!
    var lastLogin : String!
    var lastName : String!
    var lat : String!
    var lng : String!
    var password : String!
    var phone : String!
    var profilePicture : String!
    var rememberCode : String!
    var rememberSelector : String!
    var trash : String!
    var username : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        activationCode = json["activation_code"].stringValue
        activationSelector = json["activation_selector"].stringValue
        active = json["active"].stringValue
        apiKey = json["api_key"].stringValue
        createdOn = json["created_on"].stringValue
        deletedAt = json["deleted_at"].stringValue
        deviceToken = json["device_token"].stringValue
        deviceType = json["device_type"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        forgottenPasswordCode = json["forgotten_password_code"].stringValue
        forgottenPasswordSelector = json["forgotten_password_selector"].stringValue
        forgottenPasswordTime = json["forgotten_password_time"].stringValue
        fullName = json["full_name"].stringValue
        id = json["id"].stringValue
        ipAddress = json["ip_address"].stringValue
        lastLogin = json["last_login"].stringValue
        lastName = json["last_name"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        password = json["password"].stringValue
        phone = json["phone"].stringValue
        profilePicture = json["profile_picture"].stringValue
        rememberCode = json["remember_code"].stringValue
        rememberSelector = json["remember_selector"].stringValue
        trash = json["trash"].stringValue
        username = json["username"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if activationCode != nil{
        	dictionary["activation_code"] = activationCode
        }
        if activationSelector != nil{
        	dictionary["activation_selector"] = activationSelector
        }
        if active != nil{
        	dictionary["active"] = active
        }
        if apiKey != nil{
        	dictionary["api_key"] = apiKey
        }
        if createdOn != nil{
        	dictionary["created_on"] = createdOn
        }
        if deletedAt != nil{
        	dictionary["deleted_at"] = deletedAt
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
        if forgottenPasswordCode != nil{
        	dictionary["forgotten_password_code"] = forgottenPasswordCode
        }
        if forgottenPasswordSelector != nil{
        	dictionary["forgotten_password_selector"] = forgottenPasswordSelector
        }
        if forgottenPasswordTime != nil{
        	dictionary["forgotten_password_time"] = forgottenPasswordTime
        }
        if fullName != nil{
        	dictionary["full_name"] = fullName
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if ipAddress != nil{
        	dictionary["ip_address"] = ipAddress
        }
        if lastLogin != nil{
        	dictionary["last_login"] = lastLogin
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
        if password != nil{
        	dictionary["password"] = password
        }
        if phone != nil{
        	dictionary["phone"] = phone
        }
        if profilePicture != nil{
        	dictionary["profile_picture"] = profilePicture
        }
        if rememberCode != nil{
        	dictionary["remember_code"] = rememberCode
        }
        if rememberSelector != nil{
        	dictionary["remember_selector"] = rememberSelector
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if username != nil{
        	dictionary["username"] = username
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		activationCode = aDecoder.decodeObject(forKey: "activation_code") as? String
		activationSelector = aDecoder.decodeObject(forKey: "activation_selector") as? String
		active = aDecoder.decodeObject(forKey: "active") as? String
		apiKey = aDecoder.decodeObject(forKey: "api_key") as? String
		createdOn = aDecoder.decodeObject(forKey: "created_on") as? String
		deletedAt = aDecoder.decodeObject(forKey: "deleted_at") as? String
		deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
		deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
		email = aDecoder.decodeObject(forKey: "email") as? String
		firstName = aDecoder.decodeObject(forKey: "first_name") as? String
		forgottenPasswordCode = aDecoder.decodeObject(forKey: "forgotten_password_code") as? String
		forgottenPasswordSelector = aDecoder.decodeObject(forKey: "forgotten_password_selector") as? String
		forgottenPasswordTime = aDecoder.decodeObject(forKey: "forgotten_password_time") as? String
		fullName = aDecoder.decodeObject(forKey: "full_name") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		ipAddress = aDecoder.decodeObject(forKey: "ip_address") as? String
		lastLogin = aDecoder.decodeObject(forKey: "last_login") as? String
		lastName = aDecoder.decodeObject(forKey: "last_name") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		password = aDecoder.decodeObject(forKey: "password") as? String
		phone = aDecoder.decodeObject(forKey: "phone") as? String
		profilePicture = aDecoder.decodeObject(forKey: "profile_picture") as? String
		rememberCode = aDecoder.decodeObject(forKey: "remember_code") as? String
		rememberSelector = aDecoder.decodeObject(forKey: "remember_selector") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		username = aDecoder.decodeObject(forKey: "username") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if activationCode != nil{
			aCoder.encode(activationCode, forKey: "activation_code")
		}
		if activationSelector != nil{
			aCoder.encode(activationSelector, forKey: "activation_selector")
		}
		if active != nil{
			aCoder.encode(active, forKey: "active")
		}
		if apiKey != nil{
			aCoder.encode(apiKey, forKey: "api_key")
		}
		if createdOn != nil{
			aCoder.encode(createdOn, forKey: "created_on")
		}
		if deletedAt != nil{
			aCoder.encode(deletedAt, forKey: "deleted_at")
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
		if forgottenPasswordCode != nil{
			aCoder.encode(forgottenPasswordCode, forKey: "forgotten_password_code")
		}
		if forgottenPasswordSelector != nil{
			aCoder.encode(forgottenPasswordSelector, forKey: "forgotten_password_selector")
		}
		if forgottenPasswordTime != nil{
			aCoder.encode(forgottenPasswordTime, forKey: "forgotten_password_time")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "full_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if ipAddress != nil{
			aCoder.encode(ipAddress, forKey: "ip_address")
		}
		if lastLogin != nil{
			aCoder.encode(lastLogin, forKey: "last_login")
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
		if password != nil{
			aCoder.encode(password, forKey: "password")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if profilePicture != nil{
			aCoder.encode(profilePicture, forKey: "profile_picture")
		}
		if rememberCode != nil{
			aCoder.encode(rememberCode, forKey: "remember_code")
		}
		if rememberSelector != nil{
			aCoder.encode(rememberSelector, forKey: "remember_selector")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}

	}

}
