//
//  CartDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 22, 2021

import Foundation
import SwiftyJSON


class CartDatum : NSObject, NSCoding{

    var address : String!
    var cartId : String!
    var discount : String!
    var discountAmount : String!
    var foodlistId : String!
    var grandTotal : String!
    var id : String!
    var item : [CartItem]!
    var lat : String!
    var lng : String!
    var name : String!
    var oldTotal : String!
    var promocode : String!
    var promocodeId : String!
    var promocodeType : String!
    var serviceFee : String!
    var storePolicy : String!
    var tax : String!
    var total : String!
    var totalQuantity : String!
    var totalRound : String!
    var delivery_type:String!
    var restaurant_service_fee: String!
    var is_close: String!
    
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        cartId = json["cart_id"].stringValue
        discount = json["discount"].stringValue
        discountAmount = json["discount_amount"].stringValue
        foodlistId = json["foodlist_id"].stringValue
        grandTotal = json["grand_total"].stringValue
        id = json["id"].stringValue
        item = [CartItem]()
        let itemArray = json["item"].arrayValue
        for itemJson in itemArray{
            let value = CartItem(fromJson: itemJson)
            item.append(value)
        }
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        name = json["name"].stringValue
        oldTotal = json["old_total"].stringValue
        promocode = json["promocode"].stringValue
        promocodeId = json["promocode_id"].stringValue
        promocodeType = json["promocode_type"].stringValue
        serviceFee = json["service_fee"].stringValue
        storePolicy = json["store_policy"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].stringValue
        totalQuantity = json["total_quantity"].stringValue
        totalRound = json["total_round"].stringValue
        delivery_type = json["delivery_type"].stringValue
        restaurant_service_fee = json["restaurant_service_fee"].stringValue
        is_close = json["is_close"].stringValue
      
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
        if cartId != nil{
        	dictionary["cart_id"] = cartId
        }
        if discount != nil{
        	dictionary["discount"] = discount
        }
        if discountAmount != nil{
        	dictionary["discount_amount"] = discountAmount
        }
        if foodlistId != nil{
        	dictionary["foodlist_id"] = foodlistId
        }
        if grandTotal != nil{
        	dictionary["grand_total"] = grandTotal
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if item != nil{
        var dictionaryElements = [[String:Any]]()
        for itemElement in item {
        	dictionaryElements.append(itemElement.toDictionary())
        }
        dictionary["item"] = dictionaryElements
        }
        if lat != nil{
        	dictionary["lat"] = lat
        }
        if lng != nil{
        	dictionary["lng"] = lng
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if oldTotal != nil{
        	dictionary["old_total"] = oldTotal
        }
        if promocode != nil{
        	dictionary["promocode"] = promocode
        }
        if promocodeId != nil{
        	dictionary["promocode_id"] = promocodeId
        }
        if promocodeType != nil{
        	dictionary["promocode_type"] = promocodeType
        }
        if serviceFee != nil{
        	dictionary["service_fee"] = serviceFee
        }
        if storePolicy != nil{
        	dictionary["store_policy"] = storePolicy
        }
        if tax != nil{
        	dictionary["tax"] = tax
        }
        if total != nil{
        	dictionary["total"] = total
        }
        if totalQuantity != nil{
        	dictionary["total_quantity"] = totalQuantity
        }
        if totalRound != nil{
        	dictionary["total_round"] = totalRound
        }
        if delivery_type != nil{
            dictionary["delivery_type"] = delivery_type
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
		cartId = aDecoder.decodeObject(forKey: "cart_id") as? String
		discount = aDecoder.decodeObject(forKey: "discount") as? String
		discountAmount = aDecoder.decodeObject(forKey: "discount_amount") as? String
		foodlistId = aDecoder.decodeObject(forKey: "foodlist_id") as? String
		grandTotal = aDecoder.decodeObject(forKey: "grand_total") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		item = aDecoder.decodeObject(forKey: "item") as? [CartItem]
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		oldTotal = aDecoder.decodeObject(forKey: "old_total") as? String
		promocode = aDecoder.decodeObject(forKey: "promocode") as? String
		promocodeId = aDecoder.decodeObject(forKey: "promocode_id") as? String
		promocodeType = aDecoder.decodeObject(forKey: "promocode_type") as? String
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		storePolicy = aDecoder.decodeObject(forKey: "store_policy") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		total = aDecoder.decodeObject(forKey: "total") as? String
		totalQuantity = aDecoder.decodeObject(forKey: "total_quantity") as? String
		totalRound = aDecoder.decodeObject(forKey: "total_round") as? String
        delivery_type = aDecoder.decodeObject(forKey: "delivery_type") as? String
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
		if cartId != nil{
			aCoder.encode(cartId, forKey: "cart_id")
		}
		if discount != nil{
			aCoder.encode(discount, forKey: "discount")
		}
		if discountAmount != nil{
			aCoder.encode(discountAmount, forKey: "discount_amount")
		}
		if foodlistId != nil{
			aCoder.encode(foodlistId, forKey: "foodlist_id")
		}
		if grandTotal != nil{
			aCoder.encode(grandTotal, forKey: "grand_total")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if item != nil{
			aCoder.encode(item, forKey: "item")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if oldTotal != nil{
			aCoder.encode(oldTotal, forKey: "old_total")
		}
		if promocode != nil{
			aCoder.encode(promocode, forKey: "promocode")
		}
		if promocodeId != nil{
			aCoder.encode(promocodeId, forKey: "promocode_id")
		}
		if promocodeType != nil{
			aCoder.encode(promocodeType, forKey: "promocode_type")
		}
		if serviceFee != nil{
			aCoder.encode(serviceFee, forKey: "service_fee")
		}
		if storePolicy != nil{
			aCoder.encode(storePolicy, forKey: "store_policy")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if totalQuantity != nil{
			aCoder.encode(totalQuantity, forKey: "total_quantity")
		}
		if totalRound != nil{
			aCoder.encode(totalRound, forKey: "total_round")
		}
        if delivery_type != nil{
            aCoder.encode(delivery_type, forKey: "delivery_type")
        }

	}

}
