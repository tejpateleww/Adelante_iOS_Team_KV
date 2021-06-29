//
//  orderDetailsData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class orderDetailsData : NSObject, NSCoding{

    var mainOrder : MainOrder!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let mainOrderJson = json["main_order"]
        if !mainOrderJson.isEmpty{
            mainOrder = MainOrder(fromJson: mainOrderJson)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if mainOrder != nil{
        	dictionary["mainOrder"] = mainOrder.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		mainOrder = aDecoder.decodeObject(forKey: "main_order") as? MainOrder
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if mainOrder != nil{
			aCoder.encode(mainOrder, forKey: "main_order")
		}

	}

}
