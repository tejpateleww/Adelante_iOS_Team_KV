//
//  Restaurantinfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 27, 2021

import Foundation
import SwiftyJSON


class Restaurantinfo : NSObject, NSCoding{

    var address : String!
    var bannerId : String!
    var createdAt : String!
    var days : String!
    var descriptionField : String!
    var distance : String!
    var favourite : String!
    var foodMenu : [FoodMenu]!
    var fromTime : String!
    var id : String!
    var image : String!
    var menuItem : [MenuItem]!
    var name : String!
    var promocode : String!
    var rating : String!
    var review : String!
    var serviceFee : String!
    var status : String!
    var tax : String!
    var toTime : String!
    var trash : String!
    var type : String!
    var updatedAt : String!
    var userId : String!
    var zipCode : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        bannerId = json["banner_id"].stringValue
        createdAt = json["created_at"].stringValue
        days = json["days"].stringValue
        descriptionField = json["description"].stringValue
        distance = json["distance"].stringValue
        favourite = json["favourite"].stringValue
        foodMenu = [FoodMenu]()
        let foodMenuArray = json["food_menu"].arrayValue
        for foodMenuJson in foodMenuArray{
            let value = FoodMenu(fromJson: foodMenuJson)
            foodMenu.append(value)
        }
        fromTime = json["from_time"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        menuItem = [MenuItem]()
        let menuItemArray = json["menu_item"].arrayValue
        for menuItemJson in menuItemArray{
            let value = MenuItem(fromJson: menuItemJson)
            menuItem.append(value)
        }
        name = json["name"].stringValue
        promocode = json["promocode"].stringValue
        rating = json["rating"].stringValue
        review = json["review"].stringValue
        serviceFee = json["service_fee"].stringValue
        status = json["status"].stringValue
        tax = json["tax"].stringValue
        toTime = json["to_time"].stringValue
        trash = json["trash"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].stringValue
        zipCode = json["zip_code"].stringValue
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
        if bannerId != nil{
        	dictionary["banner_id"] = bannerId
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if days != nil{
        	dictionary["days"] = days
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if distance != nil{
        	dictionary["distance"] = distance
        }
        if favourite != nil{
        	dictionary["favourite"] = favourite
        }
        if foodMenu != nil{
        var dictionaryElements = [[String:Any]]()
        for foodMenuElement in foodMenu {
        	dictionaryElements.append(foodMenuElement.toDictionary())
        }
        dictionary["foodMenu"] = dictionaryElements
        }
        if fromTime != nil{
        	dictionary["from_time"] = fromTime
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if menuItem != nil{
        var dictionaryElements = [[String:Any]]()
        for menuItemElement in menuItem {
        	dictionaryElements.append(menuItemElement.toDictionary())
        }
        dictionary["menuItem"] = dictionaryElements
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if promocode != nil{
        	dictionary["promocode"] = promocode
        }
        if rating != nil{
        	dictionary["rating"] = rating
        }
        if review != nil{
        	dictionary["review"] = review
        }
        if serviceFee != nil{
        	dictionary["service_fee"] = serviceFee
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if tax != nil{
        	dictionary["tax"] = tax
        }
        if toTime != nil{
        	dictionary["to_time"] = toTime
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if type != nil{
        	dictionary["type"] = type
        }
        if updatedAt != nil{
        	dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
        	dictionary["user_id"] = userId
        }
        if zipCode != nil{
        	dictionary["zip_code"] = zipCode
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
		bannerId = aDecoder.decodeObject(forKey: "banner_id") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		days = aDecoder.decodeObject(forKey: "days") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		favourite = aDecoder.decodeObject(forKey: "favourite") as? String
		foodMenu = aDecoder.decodeObject(forKey: "food_menu") as? [FoodMenu]
		fromTime = aDecoder.decodeObject(forKey: "from_time") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		menuItem = aDecoder.decodeObject(forKey: "menu_item") as? [MenuItem]
		name = aDecoder.decodeObject(forKey: "name") as? String
		promocode = aDecoder.decodeObject(forKey: "promocode") as? String
		rating = aDecoder.decodeObject(forKey: "rating") as? String
		review = aDecoder.decodeObject(forKey: "review") as? String
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		toTime = aDecoder.decodeObject(forKey: "to_time") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		type = aDecoder.decodeObject(forKey: "type") as? String
		updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
		zipCode = aDecoder.decodeObject(forKey: "zip_code") as? String
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
		if bannerId != nil{
			aCoder.encode(bannerId, forKey: "banner_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if days != nil{
			aCoder.encode(days, forKey: "days")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
		}
		if favourite != nil{
			aCoder.encode(favourite, forKey: "favourite")
		}
		if foodMenu != nil{
			aCoder.encode(foodMenu, forKey: "food_menu")
		}
		if fromTime != nil{
			aCoder.encode(fromTime, forKey: "from_time")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if menuItem != nil{
			aCoder.encode(menuItem, forKey: "menu_item")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if promocode != nil{
			aCoder.encode(promocode, forKey: "promocode")
		}
		if rating != nil{
			aCoder.encode(rating, forKey: "rating")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}
		if serviceFee != nil{
			aCoder.encode(serviceFee, forKey: "service_fee")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if toTime != nil{
			aCoder.encode(toTime, forKey: "to_time")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if zipCode != nil{
			aCoder.encode(zipCode, forKey: "zip_code")
		}

	}

}
