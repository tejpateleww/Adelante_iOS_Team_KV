//
//  ResposneInitClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 17, 2020

import Foundation
import SwiftyJSON


class ResposneInitClass : NSObject, NSCoding{

    var message : String!
    var status : Bool!
    var update : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        message = json["message"].stringValue
        status = json["status"].boolValue
        update = json["update"].boolValue
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
        if status != nil{
        	dictionary["status"] = status
        }
        if update != nil{
        	dictionary["update"] = update
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
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		update = aDecoder.decodeObject(forKey: "update") as? Bool
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
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if update != nil{
			aCoder.encode(update, forKey: "update")
		}

	}

}
