//
//  CardList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 4, 2021

import Foundation
import SwiftyJSON


class CardList : NSObject, NSCoding{

    var cardHolderName : String!
    var cardImage : String!
    var cardNum : String!
    var cardType : String!
    var expDateMonthYear : String!
    var formatedCardNo : String!
    var id : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        cardHolderName = json["card_holder_name"].stringValue
        cardImage = json["card_image"].stringValue
        cardNum = json["card_num"].stringValue
        cardType = json["card_type"].stringValue
        expDateMonthYear = json["exp_date_month_year"].stringValue
        formatedCardNo = json["formated_card_no"].stringValue
        id = json["id"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if cardHolderName != nil{
        	dictionary["card_holder_name"] = cardHolderName
        }
        if cardImage != nil{
        	dictionary["card_image"] = cardImage
        }
        if cardNum != nil{
        	dictionary["card_num"] = cardNum
        }
        if cardType != nil{
        	dictionary["card_type"] = cardType
        }
        if expDateMonthYear != nil{
        	dictionary["exp_date_month_year"] = expDateMonthYear
        }
        if formatedCardNo != nil{
        	dictionary["formated_card_no"] = formatedCardNo
        }
        if id != nil{
        	dictionary["id"] = id
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		cardHolderName = aDecoder.decodeObject(forKey: "card_holder_name") as? String
		cardImage = aDecoder.decodeObject(forKey: "card_image") as? String
		cardNum = aDecoder.decodeObject(forKey: "card_num") as? String
		cardType = aDecoder.decodeObject(forKey: "card_type") as? String
		expDateMonthYear = aDecoder.decodeObject(forKey: "exp_date_month_year") as? String
		formatedCardNo = aDecoder.decodeObject(forKey: "formated_card_no") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if cardHolderName != nil{
			aCoder.encode(cardHolderName, forKey: "card_holder_name")
		}
		if cardImage != nil{
			aCoder.encode(cardImage, forKey: "card_image")
		}
		if cardNum != nil{
			aCoder.encode(cardNum, forKey: "card_num")
		}
		if cardType != nil{
			aCoder.encode(cardType, forKey: "card_type")
		}
		if expDateMonthYear != nil{
			aCoder.encode(expDateMonthYear, forKey: "exp_date_month_year")
		}
		if formatedCardNo != nil{
			aCoder.encode(formatedCardNo, forKey: "formated_card_no")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}

	}

}
