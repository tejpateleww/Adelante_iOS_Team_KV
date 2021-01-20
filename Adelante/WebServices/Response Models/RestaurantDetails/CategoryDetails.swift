//
//  CategoryDetails.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 18, 2021

import Foundation
import SwiftyJSON


class CategoryDetails : NSObject, NSCoding{

    var burger : [Burger]!
    var fastFood : [FastFood]!
    var pizza : [Pizza]!
    var sandwich : [Sandwich]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        burger = [Burger]()
        let burgerArray = json["burger"].arrayValue
        for burgerJson in burgerArray{
            let value = Burger(fromJson: burgerJson)
            burger.append(value)
        }
        fastFood = [FastFood]()
        let fastFoodArray = json["fast food"].arrayValue
        for fastFoodJson in fastFoodArray{
            let value = FastFood(fromJson: fastFoodJson)
            fastFood.append(value)
        }
        pizza = [Pizza]()
        let pizzaArray = json["pizza"].arrayValue
        for pizzaJson in pizzaArray{
            let value = Pizza(fromJson: pizzaJson)
            pizza.append(value)
        }
        sandwich = [Sandwich]()
        let sandwichArray = json["sandwich"].arrayValue
        for sandwichJson in sandwichArray{
            let value = Sandwich(fromJson: sandwichJson)
            sandwich.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if burger != nil{
        var dictionaryElements = [[String:Any]]()
        for burgerElement in burger {
        	dictionaryElements.append(burgerElement.toDictionary())
        }
        dictionary["burger"] = dictionaryElements
        }
        if fastFood != nil{
        var dictionaryElements = [[String:Any]]()
        for fastFoodElement in fastFood {
        	dictionaryElements.append(fastFoodElement.toDictionary())
        }
        dictionary["fastFood"] = dictionaryElements
        }
        if pizza != nil{
        var dictionaryElements = [[String:Any]]()
        for pizzaElement in pizza {
        	dictionaryElements.append(pizzaElement.toDictionary())
        }
        dictionary["pizza"] = dictionaryElements
        }
        if sandwich != nil{
        var dictionaryElements = [[String:Any]]()
        for sandwichElement in sandwich {
        	dictionaryElements.append(sandwichElement.toDictionary())
        }
        dictionary["sandwich"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		burger = aDecoder.decodeObject(forKey: "burger") as? [Burger]
		fastFood = aDecoder.decodeObject(forKey: "fast food") as? [FastFood]
		pizza = aDecoder.decodeObject(forKey: "pizza") as? [Pizza]
		sandwich = aDecoder.decodeObject(forKey: "sandwich") as? [Sandwich]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if burger != nil{
			aCoder.encode(burger, forKey: "burger")
		}
		if fastFood != nil{
			aCoder.encode(fastFood, forKey: "fast food")
		}
		if pizza != nil{
			aCoder.encode(pizza, forKey: "pizza")
		}
		if sandwich != nil{
			aCoder.encode(sandwich, forKey: "sandwich")
		}

	}

}
