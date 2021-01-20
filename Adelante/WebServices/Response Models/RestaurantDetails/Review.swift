//
//  Review.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 18, 2021

import Foundation
import SwiftyJSON


class Review : NSObject, NSCoding{

    var rating : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        rating = json["rating"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if rating != nil{
        	dictionary["rating"] = rating
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		rating = aDecoder.decodeObject(forKey: "rating") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if rating != nil{
			aCoder.encode(rating, forKey: "rating")
		}

	}

}
