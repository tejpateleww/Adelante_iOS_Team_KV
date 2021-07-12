//
//  FoodMenu.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 12, 2021

import Foundation
import SwiftyJSON


class FoodMenu : NSObject, NSCoding{

    var categoryId : String!
    var categoryName : String!
    var subMenu : [SubMenu]!
    var isExpanded : Bool = false
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        categoryId = json["category_id"].stringValue
        categoryName = json["category_name"].stringValue
        subMenu = [SubMenu]()
        let subMenuArray = json["sub_menu"].arrayValue
        for subMenuJson in subMenuArray{
            let value = SubMenu(fromJson: subMenuJson)
            subMenu.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if categoryId != nil{
        	dictionary["category_id"] = categoryId
        }
        if categoryName != nil{
        	dictionary["category_name"] = categoryName
        }
        if subMenu != nil{
        var dictionaryElements = [[String:Any]]()
        for subMenuElement in subMenu {
        	dictionaryElements.append(subMenuElement.toDictionary())
        }
        dictionary["subMenu"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
		categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
		subMenu = aDecoder.decodeObject(forKey: "sub_menu") as? [SubMenu]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if categoryName != nil{
			aCoder.encode(categoryName, forKey: "category_name")
		}
		if subMenu != nil{
			aCoder.encode(subMenu, forKey: "sub_menu")
		}

	}

}
