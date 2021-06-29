//
//  orderData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 9, 2021

import Foundation
import SwiftyJSON


class orderData : NSObject, NSCoding{

    var address : String!
    var descriptionField : String!
    var distance : String!
    var image : String!
    var lat : String!
    var lng : String!
    var orderId : String!
    var rating : Float!
    var restaurantId : String!
    var restaurantName : String!
    var review : Int!
    var serviceFee : String!
    var storePolicy : String!
    var street : String!
    var subOrder : [SubOrder]!
    var subTotal : String!
    var tax : String!
    var total : String!
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
        descriptionField = json["description"].stringValue
        distance = json["distance"].stringValue
        image = json["image"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        orderId = json["order_id"].stringValue
        rating = json["rating"].floatValue
        restaurantId = json["restaurant_id"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        review = json["review"].intValue
        serviceFee = json["service_fee"].stringValue
        storePolicy = json["store_policy"].stringValue
        street = json["street"].stringValue
        subOrder = [SubOrder]()
        let subOrderArray = json["sub_order"].arrayValue
        for subOrderJson in subOrderArray{
            let value = SubOrder(fromJson: subOrderJson)
            subOrder.append(value)
        }
        subTotal = json["sub_total"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].stringValue
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
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if distance != nil{
        	dictionary["distance"] = distance
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if lat != nil{
        	dictionary["lat"] = lat
        }
        if lng != nil{
        	dictionary["lng"] = lng
        }
        if orderId != nil{
        	dictionary["order_id"] = orderId
        }
        if rating != nil{
        	dictionary["rating"] = rating
        }
        if restaurantId != nil{
        	dictionary["restaurant_id"] = restaurantId
        }
        if restaurantName != nil{
        	dictionary["restaurant_name"] = restaurantName
        }
        if review != nil{
        	dictionary["review"] = review
        }
        if serviceFee != nil{
        	dictionary["service_fee"] = serviceFee
        }
        if storePolicy != nil{
        	dictionary["store_policy"] = storePolicy
        }
        if street != nil{
        	dictionary["street"] = street
        }
        if subOrder != nil{
        var dictionaryElements = [[String:Any]]()
        for subOrderElement in subOrder {
        	dictionaryElements.append(subOrderElement.toDictionary())
        }
        dictionary["subOrder"] = dictionaryElements
        }
        if subTotal != nil{
        	dictionary["sub_total"] = subTotal
        }
        if tax != nil{
        	dictionary["tax"] = tax
        }
        if total != nil{
        	dictionary["total"] = total
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
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		orderId = aDecoder.decodeObject(forKey: "order_id") as? String
		rating = aDecoder.decodeObject(forKey: "rating") as? Float
		restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
		restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
		review = aDecoder.decodeObject(forKey: "review") as? Int
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		storePolicy = aDecoder.decodeObject(forKey: "store_policy") as? String
		street = aDecoder.decodeObject(forKey: "street") as? String
		subOrder = aDecoder.decodeObject(forKey: "sub_order") as? [SubOrder]
		subTotal = aDecoder.decodeObject(forKey: "sub_total") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		total = aDecoder.decodeObject(forKey: "total") as? String
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
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if orderId != nil{
			aCoder.encode(orderId, forKey: "order_id")
		}
		if rating != nil{
			aCoder.encode(rating, forKey: "rating")
		}
		if restaurantId != nil{
			aCoder.encode(restaurantId, forKey: "restaurant_id")
		}
		if restaurantName != nil{
			aCoder.encode(restaurantName, forKey: "restaurant_name")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}
		if serviceFee != nil{
			aCoder.encode(serviceFee, forKey: "service_fee")
		}
		if storePolicy != nil{
			aCoder.encode(storePolicy, forKey: "store_policy")
		}
		if street != nil{
			aCoder.encode(street, forKey: "street")
		}
		if subOrder != nil{
			aCoder.encode(subOrder, forKey: "sub_order")
		}
		if subTotal != nil{
			aCoder.encode(subTotal, forKey: "sub_total")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if zipCode != nil{
			aCoder.encode(zipCode, forKey: "zip_code")
		}

	}

}
