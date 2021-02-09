//
//  orderVariant.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 9, 2021

import Foundation
import SwiftyJSON


class orderVariant : NSObject, NSCoding{

    var groupName : String!
    var id : String!
    var name : String!
    var price : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        groupName = json["group_name"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        price = json["price"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if groupName != nil{
        	dictionary["group_name"] = groupName
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if price != nil{
        	dictionary["price"] = price
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		groupName = aDecoder.decodeObject(forKey: "group_name") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		price = aDecoder.decodeObject(forKey: "price") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if groupName != nil{
			aCoder.encode(groupName, forKey: "group_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}

	}

}
