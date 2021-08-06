//
//  MainOrder.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 5, 2021

import Foundation
import SwiftyJSON


class MainOrder : NSObject, NSCoding{

    var address : String!
    var createdAt : String!
    var discount : String!
    var discountAmount : String!
    var item : [Item]!
    var itemQuantity : String!
    var orderId : String!
    var promocodeId : String!
    var promocodeType : String!
    var qrcode : String!
    var restaurantId : String!
    var restaurantName : String!
    var serviceFee : String!
    var shareOrder : String!
    var street : String!
    var subTotal : String!
    var tax : String!
    var total : String!
    var totalRound : String!
    var username : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        address = json["address"].stringValue
        createdAt = json["created_at"].stringValue
        discount = json["discount"].stringValue
        discountAmount = json["discount_amount"].stringValue
        item = [Item]()
        let itemArray = json["item"].arrayValue
        for itemJson in itemArray{
            let value = Item(fromJson: itemJson)
            item.append(value)
        }
        itemQuantity = json["item_quantity"].stringValue
        orderId = json["order_id"].stringValue
        promocodeId = json["promocode_id"].stringValue
        promocodeType = json["promocode_type"].stringValue
        qrcode = json["qrcode"].stringValue
        restaurantId = json["restaurant_id"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        serviceFee = json["service_fee"].stringValue
        shareOrder = json["share_order"].stringValue
        street = json["street"].stringValue
        subTotal = json["sub_total"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].stringValue
        totalRound = json["total_round"].stringValue
        username = json["username"].stringValue
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
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if discount != nil{
        	dictionary["discount"] = discount
        }
        if discountAmount != nil{
        	dictionary["discount_amount"] = discountAmount
        }
        if item != nil{
        var dictionaryElements = [[String:Any]]()
        for itemElement in item {
        	dictionaryElements.append(itemElement.toDictionary())
        }
        dictionary["item"] = dictionaryElements
        }
        if itemQuantity != nil{
        	dictionary["item_quantity"] = itemQuantity
        }
        if orderId != nil{
        	dictionary["order_id"] = orderId
        }
        if promocodeId != nil{
        	dictionary["promocode_id"] = promocodeId
        }
        if promocodeType != nil{
        	dictionary["promocode_type"] = promocodeType
        }
        if qrcode != nil{
        	dictionary["qrcode"] = qrcode
        }
        if restaurantId != nil{
        	dictionary["restaurant_id"] = restaurantId
        }
        if restaurantName != nil{
        	dictionary["restaurant_name"] = restaurantName
        }
        if serviceFee != nil{
        	dictionary["service_fee"] = serviceFee
        }
        if shareOrder != nil{
        	dictionary["share_order"] = shareOrder
        }
        if street != nil{
        	dictionary["street"] = street
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
        if totalRound != nil{
        	dictionary["total_round"] = totalRound
        }
        if username != nil{
        	dictionary["username"] = username
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
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		discount = aDecoder.decodeObject(forKey: "discount") as? String
		discountAmount = aDecoder.decodeObject(forKey: "discount_amount") as? String
		item = aDecoder.decodeObject(forKey: "item") as? [Item]
		itemQuantity = aDecoder.decodeObject(forKey: "item_quantity") as? String
		orderId = aDecoder.decodeObject(forKey: "order_id") as? String
		promocodeId = aDecoder.decodeObject(forKey: "promocode_id") as? String
		promocodeType = aDecoder.decodeObject(forKey: "promocode_type") as? String
		qrcode = aDecoder.decodeObject(forKey: "qrcode") as? String
		restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
		restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		shareOrder = aDecoder.decodeObject(forKey: "share_order") as? String
		street = aDecoder.decodeObject(forKey: "street") as? String
		subTotal = aDecoder.decodeObject(forKey: "sub_total") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		total = aDecoder.decodeObject(forKey: "total") as? String
		totalRound = aDecoder.decodeObject(forKey: "total_round") as? String
		username = aDecoder.decodeObject(forKey: "username") as? String
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
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if discount != nil{
			aCoder.encode(discount, forKey: "discount")
		}
		if discountAmount != nil{
			aCoder.encode(discountAmount, forKey: "discount_amount")
		}
		if item != nil{
			aCoder.encode(item, forKey: "item")
		}
		if itemQuantity != nil{
			aCoder.encode(itemQuantity, forKey: "item_quantity")
		}
		if orderId != nil{
			aCoder.encode(orderId, forKey: "order_id")
		}
		if promocodeId != nil{
			aCoder.encode(promocodeId, forKey: "promocode_id")
		}
		if promocodeType != nil{
			aCoder.encode(promocodeType, forKey: "promocode_type")
		}
		if qrcode != nil{
			aCoder.encode(qrcode, forKey: "qrcode")
		}
		if restaurantId != nil{
			aCoder.encode(restaurantId, forKey: "restaurant_id")
		}
		if restaurantName != nil{
			aCoder.encode(restaurantName, forKey: "restaurant_name")
		}
		if serviceFee != nil{
			aCoder.encode(serviceFee, forKey: "service_fee")
		}
		if shareOrder != nil{
			aCoder.encode(shareOrder, forKey: "share_order")
		}
		if street != nil{
			aCoder.encode(street, forKey: "street")
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
		if totalRound != nil{
			aCoder.encode(totalRound, forKey: "total_round")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}

	}

}
