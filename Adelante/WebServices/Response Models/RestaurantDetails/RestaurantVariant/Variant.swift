//
//  Variant.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 1, 2021

import Foundation
import SwiftyJSON


class Variant : NSObject, NSCoding{

    var defaultItem : String!
    var groupId : String!
    var groupName : String!
    var menuChoice : String!
    var option : [Option]!
    var variantItem : String!
    var isExpanded : Bool = true
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        defaultItem = json["default_item"].stringValue
        groupId = json["group_id"].stringValue
        groupName = json["group_name"].stringValue
        menuChoice = json["menu_choice"].stringValue
        option = [Option]()
        let optionArray = json["option"].arrayValue
        for optionJson in optionArray{
            let value = Option(fromJson: optionJson)
            option.append(value)
        }
        variantItem = json["variant_item"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if defaultItem != nil{
            dictionary["default_item"] = defaultItem
        }
        if groupId != nil{
        	dictionary["group_id"] = groupId
        }
        if groupName != nil{
        	dictionary["group_name"] = groupName
        }
        if menuChoice != nil{
        	dictionary["menu_choice"] = menuChoice
        }
        if option != nil{
        var dictionaryElements = [[String:Any]]()
        for optionElement in option {
        	dictionaryElements.append(optionElement.toDictionary())
        }
        dictionary["option"] = dictionaryElements
        }
        if variantItem != nil{
            dictionary["variant_item"] = variantItem
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        defaultItem = aDecoder.decodeObject(forKey: "default_item") as? String
		groupId = aDecoder.decodeObject(forKey: "group_id") as? String
		groupName = aDecoder.decodeObject(forKey: "group_name") as? String
		menuChoice = aDecoder.decodeObject(forKey: "menu_choice") as? String
		option = aDecoder.decodeObject(forKey: "option") as? [Option]
        variantItem = aDecoder.decodeObject(forKey: "variant_item") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
        if defaultItem != nil{
            aCoder.encode(defaultItem, forKey: "default_item")
        }
		if groupId != nil{
			aCoder.encode(groupId, forKey: "group_id")
		}
		if groupName != nil{
			aCoder.encode(groupName, forKey: "group_name")
		}
		if menuChoice != nil{
			aCoder.encode(menuChoice, forKey: "menu_choice")
		}
		if option != nil{
			aCoder.encode(option, forKey: "option")
		}
        if variantItem != nil{
            aCoder.encode(variantItem, forKey: "variant_item")
        }
	}

}
