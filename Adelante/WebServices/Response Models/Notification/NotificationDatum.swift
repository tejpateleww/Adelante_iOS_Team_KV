//
//  NotificationDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on May 6, 2021

import Foundation
import SwiftyJSON


class NotificationDatum : NSObject, NSCoding{

    var descriptionField : String!
    var id : String!
    var notificationTitle : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        descriptionField = json["description"].stringValue
        id = json["id"].stringValue
        notificationTitle = json["notification_title"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if notificationTitle != nil{
        	dictionary["notification_title"] = notificationTitle
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		notificationTitle = aDecoder.decodeObject(forKey: "notification_title") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if notificationTitle != nil{
			aCoder.encode(notificationTitle, forKey: "notification_title")
		}

	}

}
