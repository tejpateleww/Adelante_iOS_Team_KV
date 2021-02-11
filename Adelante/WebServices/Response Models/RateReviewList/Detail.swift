//
//  Detail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 10, 2021

import Foundation
import SwiftyJSON


class Detail : NSObject, NSCoding{

    var feedback : String!
    var fullName : String!
    var rating : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        feedback = json["feedback"].stringValue
        fullName = json["full_name"].stringValue
        rating = json["rating"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if feedback != nil{
        	dictionary["feedback"] = feedback
        }
        if fullName != nil{
        	dictionary["full_name"] = fullName
        }
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
		feedback = aDecoder.decodeObject(forKey: "feedback") as? String
		fullName = aDecoder.decodeObject(forKey: "full_name") as? String
		rating = aDecoder.decodeObject(forKey: "rating") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if feedback != nil{
			aCoder.encode(feedback, forKey: "feedback")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "full_name")
		}
		if rating != nil{
			aCoder.encode(rating, forKey: "rating")
		}

	}

}
