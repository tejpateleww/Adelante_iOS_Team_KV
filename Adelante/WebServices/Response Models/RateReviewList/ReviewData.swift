//
//  ReviewData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 10, 2021

import Foundation
import SwiftyJSON


class ReviewData : NSObject, NSCoding{

    var address : String!
    var details : [Detail]!
    var image : String!
    var name : String!
    var rating : String!
    var review : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        details = [Detail]()
        let detailsArray = json["details"].arrayValue
        for detailsJson in detailsArray{
            let value = Detail(fromJson: detailsJson)
            details.append(value)
        }
        image = json["image"].stringValue
        name = json["name"].stringValue
        rating = json["rating"].stringValue
        review = json["review"].stringValue
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
        if details != nil{
        var dictionaryElements = [[String:Any]]()
        for detailsElement in details {
        	dictionaryElements.append(detailsElement.toDictionary())
        }
        dictionary["details"] = dictionaryElements
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if rating != nil{
        	dictionary["rating"] = rating
        }
        if review != nil{
        	dictionary["review"] = review
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
		details = aDecoder.decodeObject(forKey: "details") as? [Detail]
		image = aDecoder.decodeObject(forKey: "image") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		rating = aDecoder.decodeObject(forKey: "rating") as? String
		review = aDecoder.decodeObject(forKey: "review") as? String
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
		if details != nil{
			aCoder.encode(details, forKey: "details")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if rating != nil{
			aCoder.encode(rating, forKey: "rating")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}

	}

}
