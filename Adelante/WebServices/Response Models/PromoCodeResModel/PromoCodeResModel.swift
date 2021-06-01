//
//  PromoCodeResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on May 24, 2021

import Foundation
import SwiftyJSON


class PromoCodeResModel : NSObject, NSCoding{

    var message : String!
    var promocode : [Promocode]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        message = json["message"].stringValue
        promocode = [Promocode]()
        let promocodeArray = json["promocode"].arrayValue
        for promocodeJson in promocodeArray{
            let value = Promocode(fromJson: promocodeJson)
            promocode.append(value)
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
        if promocode != nil{
        var dictionaryElements = [[String:Any]]()
        for promocodeElement in promocode {
        	dictionaryElements.append(promocodeElement.toDictionary())
        }
        dictionary["promocode"] = dictionaryElements
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
		promocode = aDecoder.decodeObject(forKey: "promocode") as? [Promocode]
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
		if promocode != nil{
			aCoder.encode(promocode, forKey: "promocode")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
