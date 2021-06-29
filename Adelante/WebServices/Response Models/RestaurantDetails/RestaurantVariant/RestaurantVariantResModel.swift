//
//  RestaurantVariantResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 1, 2021

import Foundation
import SwiftyJSON


class RestaurantVariantResModel : NSObject, NSCoding{

    var message : String!
    var status : Bool!
    var variants : [Variant]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        message = json["message"].stringValue
        status = json["status"].boolValue
        variants = [Variant]()
        let variantsArray = json["data"].arrayValue
        for variantsJson in variantsArray{
            let value = Variant(fromJson: variantsJson)
            variants.append(value)
        }
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
        if variants != nil{
        var dictionaryElements = [[String:Any]]()
        for variantsElement in variants {
        	dictionaryElements.append(variantsElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
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
		variants = aDecoder.decodeObject(forKey: "data") as? [Variant]
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
		if variants != nil{
			aCoder.encode(variants, forKey: "data")
		}

	}

}
