//
//  ApplyPromoDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 22, 2021

import Foundation
import SwiftyJSON


class ApplyPromoDatum : NSObject, NSCoding{

    var discount : String!
    var discountAmount : String!
    var grandTotal : String!
    var id : String!
    var name : String!
    var oldTotal : String!
    var promocodeType : String!
    var serviceFee : String!
    var tax : String!
    var total : String!
    var totalRound : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        discount = json["discount"].stringValue
        discountAmount = json["discount_amount"].stringValue
        grandTotal = json["grand_total"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        oldTotal = json["old_total"].stringValue
        promocodeType = json["promocode_type"].stringValue
        serviceFee = json["service_fee"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].stringValue
        totalRound = json["total_round"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if discount != nil{
        	dictionary["discount"] = discount
        }
        if discountAmount != nil{
        	dictionary["discount_amount"] = discountAmount
        }
        if grandTotal != nil{
        	dictionary["grand_total"] = grandTotal
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if oldTotal != nil{
        	dictionary["old_total"] = oldTotal
        }
        if promocodeType != nil{
        	dictionary["promocode_type"] = promocodeType
        }
        if serviceFee != nil{
        	dictionary["service_fee"] = serviceFee
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
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		discount = aDecoder.decodeObject(forKey: "discount") as? String
		discountAmount = aDecoder.decodeObject(forKey: "discount_amount") as? String
		grandTotal = aDecoder.decodeObject(forKey: "grand_total") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		oldTotal = aDecoder.decodeObject(forKey: "old_total") as? String
		promocodeType = aDecoder.decodeObject(forKey: "promocode_type") as? String
		serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		total = aDecoder.decodeObject(forKey: "total") as? String
		totalRound = aDecoder.decodeObject(forKey: "total_round") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if discount != nil{
			aCoder.encode(discount, forKey: "discount")
		}
		if discountAmount != nil{
			aCoder.encode(discountAmount, forKey: "discount_amount")
		}
		if grandTotal != nil{
			aCoder.encode(grandTotal, forKey: "grand_total")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if oldTotal != nil{
			aCoder.encode(oldTotal, forKey: "old_total")
		}
		if promocodeType != nil{
			aCoder.encode(promocodeType, forKey: "promocode_type")
		}
		if serviceFee != nil{
			aCoder.encode(serviceFee, forKey: "service_fee")
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

	}

}
