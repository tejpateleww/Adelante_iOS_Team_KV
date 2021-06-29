//
//  AddPaymentResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 4, 2021

import Foundation
import SwiftyJSON


class AddPaymentResModel : NSObject, NSCoding{

    var cards : [CardList]!
    var message : String!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        cards = [CardList]()
        let cardsArray = json["cards"].arrayValue
        for cardsJson in cardsArray{
            let value = CardList(fromJson: cardsJson)
            cards.append(value)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if cards != nil{
        var dictionaryElements = [[String:Any]]()
        for cardsElement in cards {
        	dictionaryElements.append(cardsElement.toDictionary())
        }
        dictionary["cards"] = dictionaryElements
        }
        if message != nil{
        	dictionary["message"] = message
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
		cards = aDecoder.decodeObject(forKey: "cards") as? [CardList]
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if cards != nil{
			aCoder.encode(cards, forKey: "cards")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
