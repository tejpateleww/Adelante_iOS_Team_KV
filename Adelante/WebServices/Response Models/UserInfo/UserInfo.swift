//
//  Userinfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 4, 2021

import Foundation
import SwiftyJSON


class Userinfo : NSObject, NSCoding{

    var message : String!
    var profile : Profile!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        message = json["message"].stringValue
        let profileJson = json["profile"]
        if !profileJson.isEmpty{
            profile = Profile(fromJson: profileJson)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if message != nil{
        	dictionary["message"] = message
        }
        if profile != nil{
        	dictionary["profile"] = profile.toDictionary()
        }
        if status != nil{
        	dictionary["status"] = status
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		message = aDecoder.decodeObject(forKey: "message") as? String
		profile = aDecoder.decodeObject(forKey: "profile") as? Profile
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if profile != nil{
			aCoder.encode(profile, forKey: "profile")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
