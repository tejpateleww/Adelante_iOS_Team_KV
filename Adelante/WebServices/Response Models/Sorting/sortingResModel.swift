//
//  sortingResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 13, 2021

import Foundation
import SwiftyJSON


class sortingResModel : NSObject, NSCoding{

    var data : [Sorting]!
    var message : String!
    var status : Bool!
    var top_selling_id : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        data = [Sorting]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = Sorting(fromJson: dataJson)
            data.append(value)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
        top_selling_id = json["top_selling_id"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if data != nil{
        var dictionaryElements = [[String:Any]]()
        for dataElement in data {
        	dictionaryElements.append(dataElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if top_selling_id != nil{
            dictionary["top_selling_id"] = top_selling_id
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		data = aDecoder.decodeObject(forKey: "data") as? [Sorting]
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
        top_selling_id = aDecoder.decodeObject(forKey: "top_selling_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
        if top_selling_id != nil{
            aCoder.encode(top_selling_id, forKey: "top_selling_id")
        }
	}

}
