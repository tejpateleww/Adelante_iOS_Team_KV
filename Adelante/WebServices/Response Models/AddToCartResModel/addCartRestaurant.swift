//
//  Restaurant.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 13, 2021

import Foundation
import SwiftyJSON


class addCartRestaurant : NSObject, NSCoding{

    var foodMenu : [FoodMenu]!
    var foodType : Int!
    var menuItem : [MenuItem]!
    var menuType : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        foodMenu = [FoodMenu]()
        let foodMenuArray = json["food_menu"].arrayValue
        for foodMenuJson in foodMenuArray{
            let value = FoodMenu(fromJson: foodMenuJson)
            foodMenu.append(value)
        }
        foodType = json["food_type"].intValue
        menuItem = [MenuItem]()
        let menuItemArray = json["menu_item"].arrayValue
        for menuItemJson in menuItemArray{
            let value = MenuItem(fromJson: menuItemJson)
            menuItem.append(value)
        }
        menuType = json["menu_type"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if foodMenu != nil{
        var dictionaryElements = [[String:Any]]()
        for foodMenuElement in foodMenu {
        	dictionaryElements.append(foodMenuElement.toDictionary())
        }
        dictionary["foodMenu"] = dictionaryElements
        }
        if foodType != nil{
        	dictionary["food_type"] = foodType
        }
        if menuItem != nil{
        var dictionaryElements = [[String:Any]]()
        for menuItemElement in menuItem {
        	dictionaryElements.append(menuItemElement.toDictionary())
        }
        dictionary["menuItem"] = dictionaryElements
        }
        if menuType != nil{
        	dictionary["menu_type"] = menuType
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		foodMenu = aDecoder.decodeObject(forKey: "food_menu") as? [FoodMenu]
		foodType = aDecoder.decodeObject(forKey: "food_type") as? Int
		menuItem = aDecoder.decodeObject(forKey: "menu_item") as? [MenuItem]
		menuType = aDecoder.decodeObject(forKey: "menu_type") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if foodMenu != nil{
			aCoder.encode(foodMenu, forKey: "food_menu")
		}
		if foodType != nil{
			aCoder.encode(foodType, forKey: "food_type")
		}
		if menuItem != nil{
			aCoder.encode(menuItem, forKey: "menu_item")
		}
		if menuType != nil{
			aCoder.encode(menuType, forKey: "menu_type")
		}

	}

}
